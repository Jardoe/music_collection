require_relative('../db/sql_runner.rb')
require_relative('album.rb')

class Artist

  attr_reader :id
  attr_accessor :name

  def initialize(options)
    @id = options['id'] if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING *;"
    values = [@name]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def all_albums()
      sql = "SELECT * FROM albums WHERE artist_id = $1"
      values = [@id]
      result = SqlRunner.run(sql, values)
      result.map { |result| Album.new(result) }
  end

  def edit_name(new_name)
    sql = "UPDATE artists
      SET name = $1
      WHERE id = $2
      RETURNING *;"
      values = [new_name, @id]
      SqlRunner.run(sql, values)
  end

  def Artist.all()
    sql = "SELECT * FROM artists"
    results = SqlRunner.run(sql)
    results.map { |result| Artist.new(result) }
  end

  def Artist.delete_all()
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end
end
