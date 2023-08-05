class Item
  attr_accessor :id, :publish_date, :archived, :author, :source, :label, :genre

  def initialize(id, genre, author, source, label, publish_date, archived = false)
    @id = id
    @genre = genre
    @author = author
    @source = source
    @label = label
    @publish_date = publish_date
    @archived = archived
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