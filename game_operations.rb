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
      game_from_json = JSON.parse(game_data)
      game_from_json.each do |game_hash|
        @games << Game.json_create(game_hash)
      end
    else
      @games = []
    end
  end

  def list
    @games.each do |game|
      puts "id: #{game.id} - Multiplayer: #{game.multiplayer ? 'Yes' : 'No'} - " \
           "Last played at: #{game.last_played_at} - Genre: #{game.genre.name} - " \
           "Author: #{game.author.first_name} #{game.author.last_name} - Source: #{game.source.name} - " \
           "Label: #{game.label.title} #{game.label.color_name} - Published: #{game.publish_date}"
    end
  end

  def add
    multiplayer = request_multiplayer
    last_played_at = request_last_played_at
    genre = @genre_operations.list
    author = @author_operations.list
    source = @source_operations.list
    label = @label_operations.list
    publish_date = request_publish_date

    game_params = {
      json_file: 'game.json',
      genre: genre,
      author: author,
      source: source,
      label: label,
      publish_date: publish_date,
      multiplayer: multiplayer,
      last_played_at: last_played_at
    }

    game = Game.new(game_params)
    @games << game
    puts 'Game added successfully'
  end

  def request_multiplayer
    puts 'Does the game support multiplayer? (Y/N):'
    gets.chomp.downcase == 'y'
  end

  def request_last_played_at
    puts 'Enter the last played date (YYYY-MM-DD):'
    Date.parse(gets.chomp)
  end

  def request_publish_date
    puts 'Enter the publish date (YYYY-MM-DD):'
    Date.parse(gets.chomp)
  end

  def save
    File.write('game.json', JSON.dump(@games))
  end
end
