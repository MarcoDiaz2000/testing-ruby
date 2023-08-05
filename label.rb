class Label
  attr_accessor :id, :title, :color_name, :items

  def initialize(title, color_name)
    @id = next_id
    @title = title
    @color_name = color_name
    @items = []
  end
  
  def next_id
    file = File.read('label.json')
    labels = JSON.parse(file)
    return 1 if labels.empty?
  
    max_id = labels.max_by { |l| l['id'] }['id']
    max_id + 1
  end

  def add_item(item)
    @items << item
    item.label = self
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'id' => @id,
      'title' => @title,
      'color_name' => @color_name,
      'items' => @items.map { |item| [item.id, item.class.to_s] }
    }.to_json(*args)
  end

  def self.json_create(object)
    label = new(object['title'], object['color_name'])
    label.instance_variable_set(:@id, object['id'])
    label.instance_variable_set(:@items, object['items'])
    label
  end
end
