class MusicAlbumOperations
  def initialize(genre_operations, label_operations, author_operations, source_operations)
    @genre_operations = genre_operations
    @label_operations = label_operations
    @author_operations = author_operations
    @source_operations = source_operations
    @albums = []
    load_albums
  end

  def load_albums
    if File.exist?('music_album.json')
      album_data = File.read('music_album.json')
      albums_from_json = JSON.parse(album_data)
      albums_from_json.each do |album_hash|
        @albums << MusicAlbum.json_create(album_hash)
      end
    else
      @albums = []
    end
  end

  def list
    @albums.each do |album|
      puts "id: #{album.id} - #{album.on_spotify ? 'Available' : 'Not available'} on Spotify " \
           "- Genre: #{album.genre.name} - Author: #{album.author.first_name} #{album.author.last_name} - " \
           "Source: #{album.source.name} - Label: #{album.label.title} #{album.label.color_name} - " \
           "Published: #{album.publish_date}"
    end
  end

  def add
    genre = @genre_operations.list
    author = @author_operations.list
    source = @source_operations.list
    label = @label_operations.list
    publish_date = request_publish_date
    on_spotify = request_on_spotify

    album_params = {
      json_file: 'music_album.json',
      genre: genre,
      author: author,
      source: source,
      label: label,
      publish_date: publish_date,
      on_spotify: on_spotify
    }

    album = MusicAlbum.new(album_params)
    @albums << album
    puts 'Album added successfully'
  end

  def request_publish_date
    puts 'Enter the publish date (YYYY-MM-DD):'
    Date.parse(gets.chomp)
  end

  def request_on_spotify
    puts 'Is the album available on Spotify? (Y/N):'
    gets.chomp.downcase == 'y'
  end

  def save
    File.write('music_album.json', JSON.dump(@albums))
  end
end
