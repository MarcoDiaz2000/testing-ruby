class GameOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @games = []
    load_games
  end

  def load_games
    if File.exist?('game.json')
      game_data = File.read('game.json')
      JSON.parse(game_data, create_additions: true).each do |game|
        @games << game
      end
    else
      @games = []
    end
  end

  def list
    @games.each { |game| puts "#{game.id}. #{game.name} - Multiplayer: #{game.multiplayer ? 'Yes' : 'No'} - Last played at: #{game.last_played_at}" }
  end

  def add
    puts 'Enter the game name:'
    name = gets.chomp

    puts 'Does the game support multiplayer? (Y/N):'
    multiplayer = gets.chomp.downcase == 'y' ? true : false

    puts 'Enter the last played date (YYYY-MM-DD):'
    last_played_at = Date.parse(gets.chomp)

    puts 'Enter the genre id:'
    genre_id = gets.chomp.to_i
    genre = @genre_operations.find_by_id(genre_id)

    puts 'Enter the author id:'
    author_id = gets.chomp.to_i
    author = @author_operations.find_by_id(author_id)

    puts 'Enter the source id:'
    source_id = gets.chomp.to_i
    source = @source_operations.find_by_id(source_id)

    puts 'Enter the label id:'
    label_id = gets.chomp.to_i
    label = @label_operations.find_by_id(label_id)

    publish_date = Date.today

    game = Game.new(genre, author, source, label, publish_date, name, multiplayer, last_played_at)
    @games << game
    puts 'Game added successfully'
  end

  def save
    File.write('game.json', JSON.dump(@games))
  end
end