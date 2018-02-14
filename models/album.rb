require_relative('../db/sql_runner.rb')

class Album

  attr_reader :id, :title, :genre, :artist_id
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @artist_id = options['artist_id'].to_i
  end

  def save()
    sql = "
    INSERT INTO albums
    (
      title,
      genre,
      artist_id
    )
    VALUES (
      $1, $2, $3
    )
    RETURNING *;"
    values = [@title, @genre, @artist_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def Album.delete_all()
    sql = "DELETE FROM albums;"
    SqlRunner.run(sql)
  end

  def Album.all()
    sql = "SELECT * FROM albums"
    results = SqlRunner.run(sql)
    results.map { |result| Album.new(result) }
  end

  def find_artist()
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    Artist.new(SqlRunner.run(sql, values)[0])
  end

  def edit_title(new_title)
    sql = "
    UPDATE albums
    SET (
    title,
    genre,
    artist_id
    ) =
    (
      $1, $2, $3
    )
    WHERE id = $4
    RETURNING *;"
    values = [new_title, @genre, @artist_id, @id]
    SqlRunner.run(sql, values)
  end
end
