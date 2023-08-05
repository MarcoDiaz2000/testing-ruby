class Item
  attr_accessor :id, :publish_date, :archived, :author, :source, :label, :genre

  def initialize(json_file, genre, author, source, label, publish_date, archived = false)
    @id = self.class.next_id(json_file)
    @genre = genre
    @author = author
    @source = source
    @label = label
    @publish_date = publish_date
    @archived = archived
  end

  def self.next_id(json_file)
    if File.exist?(json_file)
      file = File.read(json_file)
      items = JSON.parse(file)
      return 1 if items.empty?
      
      max_id = items.max_by { |item| item['id'] }['id']
      return max_id + 1
    end
    1
  end

    def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'author' => @author.id,
      'genre' => @genre.id,
      'source' => @source.id,
      'label' => @label.id,
      'publish_date' => @publish_date,
      'archived' => @archived
    }.to_json(*args)
  end

  def can_be_archived?
    Time.now.year - @publish_date.year > 10
  end

  def move_to_archive
    @archived = true if can_be_archived?
  end
end