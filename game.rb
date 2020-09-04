class Game
  attr_accessor :player, :computer, :sequence, :colors
  def initialize
    @colors = %w(blue yellow green red orange pink)
    @guess = []
    puts "\nWelcome to Mastermind. Codemaker or codebreaker?"
    make_or_break
    @@turns = 0
    get_guess(@breaker)
  end

  def make_or_break
    answer = gets.chomp.downcase
    if answer == "codemaker"
      @maker = "player"
      @breaker = "computer"
      generate_sequence("player")
    elsif answer == "codebreaker"
      @maker = "computer"
      @breaker = "player"
      generate_sequence("computer")
    else
      puts "\nInvalid answer\n"
      make_or_break
    end
  end

  def generate_sequence(maker)
    if maker == "player"
      puts "\nChoose four of these colors. No repeats, no blanks."
      p @colors
      @sequence = gets.chomp.downcase.split(" ")
      puts "====================="
      if @sequence.size != 4
        puts "\nInvalid number of colors\n\n"
        generate_sequence("player")
      elsif @sequence.any? { |color| !@colors.include?(color) }
        puts "\nInvalid color choice\n\n"
        generate_sequence("player")
      else
        return @sequence
      end
    else
      array = @colors.shuffle
      array = array.pop(4)
      @sequence = array
    end
    p @sequence
  end

  def get_guess(breaker)
    if breaker == "player"
      puts "\nGuess the four colors: "
      @guess = gets.chomp.downcase.split(" ")
      compare_guess(@guess, breaker)
    else
      computer_guess
      print "\n\nComputer guess: "
      p @guess
      compare_guess(@guess, breaker)
    end
  end

  def computer_guess
    colors_left = @colors
    if @feedback_array.nil?
      4.times do |i|
        @guess[i] = colors_left.shuffle.pop
        colors_left.delete(@guess[i])
      end
    else
      spots_left = [0, 1, 2, 3]
      new_guess = []
      changes = []

      @feedback_array.each_with_index do |feed, idx|
        if feed == "Right"
          new_guess[idx] = @guess[idx]
          spots_left.delete(idx)
        elsif feed == "Close"
          p "Colors left: #{colors_left}"
          changes.push(@guess[idx])
        elsif feed == "Wrong"
          changes.push(colors_left.shuffle.pop)
          colors_left.delete(changes.last)
        end
      end

      spots_left.each do |spot|
        new_guess[spot] = changes.pop
      end
      @guess = new_guess
    end
  end

  def compare_guess(guess, breaker)
    # if computer is guessing
    if breaker == "computer"
      if is_correct?(guess)
        puts "\nThe computer has won!\n"
        if play_again?
          initialize
        else
          exit
        end
      else
        @@turns += 1
        puts "\nComputer guessed incorrectly.\n"
        feedback(guess)
        if @@turns < 12
          puts "#{12 - @@turns} turns remaining."
          puts "Press enter to continue"
          gets.chomp
          get_guess(breaker)
        else
          puts "\nThe computer has lost!\n"
          if play_again?
            initialize
          else
            exit
          end
        end
      end
    # if player is guessing
    elsif breaker == "player"
      if is_correct?(guess)
        puts "\nCongrats, you guessed correctly!\n"
        if play_again?
          initialize
        else
          exit
        end
      else
        @@turns += 1
        puts ""
        feedback(guess)
        if @@turns < 12
          print "\nIncorrect. #{12 - @@turns} turns remaining.\n"
          get_guess(breaker)
        else
          puts "\nSorry, game over.\n"
          if play_again?
            initialize
          else
            exit
          end
        end
      end
    end
  end

  def is_correct?(guess)
    true if guess == @sequence
  end

  def feedback(guess)
    @feedback_array = []
    guess.each_with_index do |color, index|
      if @sequence.include?(color)
        if color == @sequence[index]
          @feedback_array[index] = "Right"
        else
          @feedback_array[index] = "Close"
        end
      else
        @feedback_array[index] = "Wrong"
      end
    end
    print @feedback_array
  end

  def play_again?
    puts "\nWould you like to play again? (y/n): "
    answer = gets.chomp
    if answer == "y"
      true
    elsif answer == "n"
      false
    else
      puts "\nInvalid answer!"
      play_again?
    end
  end

end

game = Game.new