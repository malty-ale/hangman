class Game
  attr_accessor :word, :word_array, :guessed_letters, :victory, :game_data
  
  def initialize
    puts "Would you like to load a game?"
    response = gets.chomp.upcase
    load_game if response == "yes"
    
    select_word
    
    @guessed_letters = []
    @guesses = 7
    @victory = false
  end
  
  def start_game   
    while @victory == false
      return if @letter == "save"
      show_board
      play_turn
      victory_check
      break if @guesses <= 0
    end
    
    if @victory == true
      "Congratulations you won!  The word was #{@word}."
    else
      "Sorry you lost.  The word was #{@word}."
    end
  end
  
  def load_game
    @game_data = File.readlines("save_game.txt")
    @game_data.map! {|i| i.strip}
    
    @word = game_data[0]
    @word_array = game_data[1].split(/\W+/)[1..-1]
    @victory == "false" ? false : true
    @guessed_letters = game_data[3].split(/\W+/)[1..-1]
    @guesses = game_data[4].to_i
    
    start_game
  end
    
  private
  
  def select_word
    words = File.readlines('5desk.txt')
    
    words.map! {|i| i.strip}

    until @word.to_s.length.between?(5,12)
      @word = words.sample
    end
    
    @word_array = @word.downcase.split(//)
  end
  
  def show_board
    @word_array.each do |i|
      if ("a".."z").include? i
        print "_ "
      else
        print "#{i} "
      end
    end
    print "\n"
    
    puts "You have #{@guesses} guesses remaining."
    
    letters = @guessed_letters.to_a.join(", ")
    
    puts "You have already guesses the following letters: #{letters}"
  end
  
  def play_turn
    puts "What letter you would like to guess?"
    @letter = gets.chomp.downcase
    
    if @letter == "save"
      save_game
      return
    end
    
    while (@guessed_letters.to_a.include? @letter) || (!("a".."z").include? @letter.downcase)
      puts "Sorry, please pick again."
      @letter = gets.chomp.downcase
    end
    
    if @word_array.include? @letter
      @word_array.map! {|i| i == @letter ? i.upcase : i}
      puts "Great, that was a successful guess!"
    else
      puts "Sorry, that was an unsuccessful guess."
      @guesses -= 1
    end
    
    @guessed_letters.to_a << @letter
  end

  def save_game
    data = [@word, @word_array, @victory, @guessed_letters, @guesses]
    data.map! {|i| i.to_s}
    
    File.open("save_game.txt","w") do |i|
      i.puts data.join("\n")
    end
  end  
  
  def victory_check
    if @word_array.all? {|i| ("A".."Z").include? i}
      @victory = true
    end
  end

end
    