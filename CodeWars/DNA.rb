
  def straight frame_no, array
    array_s = array.map {|x| x}
    if frame_no == 2
      array_s.slice!(0)
      input = Proc.new do |x|
        $frame_2 << x
      end
    elsif frame_no == 3
      array_s.slice!(0,2)
      input = Proc.new do |x|
        $frame_3 << x
      end
    else
      input = Proc.new do |x|
        $frame_1 << x
      end
    end
    translate array_s, input
  end

  def reverse frame_no, array
    comp = {"A" => "T", "G" => "C", "T" => "A", "C" => "G"}
    array_r = array.map {|x| comp[x]}
    array_r.reverse!
    if frame_no == 2
      array_r.slice!(0)
      input = Proc.new do |x|
        $frame_r2 << x
      end
    elsif frame_no == 3
      array_r.slice!(0,2)
      input = Proc.new do |x|
        $frame_r3 << x
      end
    else
      input = Proc.new do |x|
        $frame_r1 << x
      end
    end
    translate array_r, input
  end

  def translate array, input
    string = ""
    array.each do |x|
      if string.length < 2
        string += x
      else
        string += x
        input.call($codons[string])
        string = ""
      end
    end
  end

def translate_with_frame(dna, frames=[1,2,3,-1,-2,-3])
  $frame_1 = []
  $frame_2 = []
  $frame_3 = []
  $frame_r1 = []
  $frame_r2 = []
  $frame_r3 = []
  original = dna.split ""
  output = []
  frame_list = {1 => $frame_1, 2 => $frame_2, 3 => $frame_3, -1 => $frame_r1, -2 => $frame_r2, -3 => $frame_r3}
  straight 1, original
  straight 2, original
  straight 3, original
  reverse 1, original
  reverse 2, original
  reverse 3, original
  if frames == nil
    frames = [1,2,3,-1,-2,-3]
  end
  frames.each do |x|
    output << frame_list[x].join
  end
  output
end
