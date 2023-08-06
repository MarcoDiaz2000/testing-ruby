class MovieOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @movies = []
    load_movies
  end

  def load_movies
    if File.exist?('movie.json')
      movie_data = File.read('movie.json')
      movies_from_json = JSON.parse(movie_data)
      movies_from_json.each do |movie_hash|
        @movies << Movie.json_create(movie_hash)
      end
    else
      @movies = []
    end
  end

  def list
    @movies.each do |movie| 
      puts "id: #{movie.id} - Silence: #{movie.silent ? 'Yes' : 'No'} - Genre: #{movie.genre.name} - Author: #{movie.author.first_name} #{movie.author.last_name} - Source: #{movie.source.name} - Label: #{movie.label.title} #{movie.label.color_name} - Published: #{movie.publish_date}"
    end
  end
  

  def add
    puts 'Is the movie silent? (Y/N):'
    silent = gets.chomp.downcase == 'y' ? true : false

    genre = @genre_operations.list

    author = @author_operations.list

    source = @source_operations.list

    label = @label_operations.list

    puts 'Enter the publish date (YYYY-MM-DD):'
    publish_date_input = gets.chomp
    publish_date = Date.parse(publish_date_input)

    movie = Movie.new('movie.json', genre, author, source, label, publish_date, silent)
    @movies << movie
    puts 'Movie added successfully'
  end

  def save
    File.write('movie.json', JSON.dump(@movies))
  end
end