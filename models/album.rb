require('pg')
require_relative('artist.rb')


class Album

  attr_reader :id
  attr_accessor :title , :genre

  def initialize(options)
    @title = options['title']
    @genre = options['genre']
    @id = options['id'].to_i if options['id']
    @artist_id = options['artist_id'].to_i
  end

  def save()
    db = PG.connect({dbname:'music_collector', host:'localhost'})
    sql = "INSERT INTO albums (title,genre,artist_id) VALUES ($1,$2,$3) RETURNING *"
    values = [@title,@genre,@artist_id]
    db.prepare("save",sql)
    @id = db.exec_prepared("save",values)[0]['id'].to_i
    db.close

  end

  def artist()
    db = PG.connect({dbname:'music_collector', host:'localhost'})
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    db.prepare("artist",sql)
    result = db.exec_prepared("artist",values)
    db.close()
    return Artist.new(result[0])

  end

  def Album.all()
    db = PG.connect({dbname:'music_collector', host:'localhost'})
    sql = "SELECT * FROM albums"
    db.prepare("all",sql)
    albums = db.exec_prepared("all")
    db.close()
    return albums.map{|album|Album.new(album)}
  end

end
