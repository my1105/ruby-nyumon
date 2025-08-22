# encoding: utf-8
def foobar(n)
  (1..n).each do |i|
    if i % 3 == 0 && i % 5 == 0
      puts "foobar"
    elsif i % 3 == 0
      puts "foo"
    elsif i % 5 == 0
      puts "bar"
    else
      puts i
    end
  end
end
