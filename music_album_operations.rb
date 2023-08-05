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
    if File.exist?('musicAlbum.json')
      album_data = File.read('musicAlbum.json')
      JSON.parse(album_data, create_additions: true).each do |album|
        @albums << album
      end
    else
      @albums = []
    end
  end

  def list
    @albums.each do |album| 
      puts "id: #{album.id} - #{album.on_spotify ? 'Available' : 'Not available'} on Spotify - Genre: #{album.genre.name} - Author: #{album.author.first_name} #{album.author.last_name} - Source: #{album.source.name} - Label: #{album.label.title} #{album.label.color_name} - Published: #{album.publish_date}"
    end
  end

  def add

    genre = @genre_operations.list

    author = @author_operations.list

    source = @source_operations.list

    label = @label_operations.list

    puts 'Enter the publish date of the album (YYYY-MM-DD):'
    publish_date_input = gets.chomp
    publish_date = Date.parse(publish_date_input)

    puts 'Is the album available on Spotify? (Y/N):'
    on_spotify = gets.chomp.downcase == 'y' ? true : false
  
    album = MusicAlbum.new('musicAlbum.json', genre, author, source, label, publish_date, on_spotify)
    @albums << album
    puts 'Album added successfully'
  end

  def save
    File.write('musicAlbum.json', JSON.dump(@albums)) 
  end
end