class Dictionary

  def initialize
    @words = load_words
    @length = 0
  end

  def load_words
    words = {}
    File.open("/usr/share/dict/words") do |file|
      file.each do |line|
        words[line.strip] = true
      end
    end
    return words
  end

  def filter(guess, word, character)
    by_length!(word.length)
    with_character!(character)
    has_structure!(guess)
  end

  def get_word
    w = @words.keys.sample
    @length = w.length
    w
  end

  def by_length!(length)
    @words.keys.select! { |word| word.length == length }
  end

  def with_character!(character)
    @words.keys.select! { |word| word.include? character }
  end

  def has_structure!(string)
    @words.keys.select! { |word| structural_match(word, string) }
  end

  def structural_match(word, string)
    string.chars.each_with_index do |index, char|
      if char != '-' && word[index] != char
        return false
      end
    end
    true
  end
end

class ShittyMan

  def initialize
    @letters = []
    @dictionary = Dictionary.new
    @word = @dictionary.get_word
    @guessed_letters = Array.new @word.chars.count
  end

  def previous_guessed_letter?(letter)
    @letters.include?(letter)
  end

  def add_letter(letter)
    @letters << letter
    @letters.uniq!
    @guessed_letters
  end

  def good_letter?(letter)
    @word.include? letter
  end

  def filter_dictionary letter
    @dictionary.filter current_guess, @word, letter
    @dictionary.get_word
  end

  def current_guess
    response = ""
    @word.chars.each do |letter|
      if @letters.include? letter
        response << letter
      else
        response << '-' 
      end
    end
    response
  end

  def win?
    if !current_guess.include? '-'
      puts "You won!"
      puts "( > ^__^)> #{current_guess} <(^__^ < )"
      exit
    end
  end
end

shitty_man = ShittyMan.new

puts "Welcome to shittyman"
while true
  puts "guess the word"
  puts shitty_man.current_guess
  guess = gets.chomp
  puts "You said #{guess}"

  if shitty_man.previous_guessed_letter? guess
    puts "You already tried that letter dumb ass!"
  elsif guess.length != 1
    puts "You cheating fuck! One letter bitch!"
  elsif shitty_man.good_letter?(guess)
    puts "well done you guess a letter right!"
    puts shitty_man.current_guess
  else
    puts "You're wrong '#{guess}' is plain wrong"
    puts "Try again..."
  end
  shitty_man.add_letter guess
  shitty_man.win?
  shitty_man.filter_dictionary guess
end