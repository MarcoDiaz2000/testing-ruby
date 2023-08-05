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
      puts "#{album.id} - #{album.on_spotify ? 'Available' : 'Not available'} on Spotify"
    end
  end

  def add
    puts 'Is the album available on Spotify? (Y/N):'
    on_spotify = gets.chomp.downcase == 'y' ? true : false

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

    album = MusicAlbum.new(genre, author, source, label, publish_date, on_spotify)
    @albums << album
    puts 'Album added successfully'
  end

  def save
    File.write('musicAlbum.json', JSON.dump(@albums)) 
  end
end