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
    @games.each do |game| 
      puts "id: #{game.id} - Multiplayer: #{game.multiplayer ? 'Yes' : 'No'} - Last played at: #{game.last_played_at} - Genre: #{game.genre.name} - Author: #{game.author.first_name} #{game.author.last_name} - Source: #{game.source.name} - Label: #{game.label.title} #{game.label.color_name} - Published: #{game.publish_date}"
    end
  end

  def add

    puts 'Does the game support multiplayer? (Y/N):'
    multiplayer = gets.chomp.downcase == 'y' ? true : false

    puts 'Enter the last played date (YYYY-MM-DD):'
    last_played_at_input = gets.chomp
    last_played_at = Date.parse(last_played_at_input)

    genre = @genre_operations.list

    author = @author_operations.list

    source = @source_operations.list

    label = @label_operations.list

    puts 'Enter the publish date of the album (YYYY-MM-DD):'
    publish_date_input = gets.chomp
    publish_date = Date.parse(publish_date_input)

    game = Game.new('game.json', genre, author, source, label, publish_date, multiplayer, last_played_at)
    @games << game
    puts 'Game added successfully'
  end

  def save
    File.write('game.json', JSON.dump(@games))
  end
end