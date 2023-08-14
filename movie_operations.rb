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
      puts "id: #{movie.id} - Silence: #{movie.silent ? 'Yes' : 'No'} - " \
           "Genre: #{movie.genre.name} - Author: #{movie.author.first_name} #{movie.author.last_name} " \
           "- Source: #{movie.source.name} - Label: #{movie.label.title} #{movie.label.color_name} - " \
           "Published: #{movie.publish_date}"
    end
  end

  def add
    silent = request_silent
    genre = @genre_operations.list
    author = @author_operations.list
    source = @source_operations.list
    label = @label_operations.list
    publish_date = request_publish_date

    movie_params = {
      json_file: 'movie.json',
      genre: genre,
      author: author,
      source: source,
      label: label,
      publish_date: publish_date,
      silent: silent
    }

    movie = Movie.new(movie_params)
    @movies << movie
    puts 'Movie added successfully'
  end

  def request_silent
    puts 'Is the movie silent? (Y/N):'
    gets.chomp.downcase == 'y'
  end

  def request_publish_date
    puts 'Enter the publish date (YYYY-MM-DD):'
    Date.parse(gets.chomp)
  end

  def save
    File.write('movie.json', JSON.dump(@movies))
  end
end
