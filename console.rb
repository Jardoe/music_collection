require('pry-byebug')
require_relative('models/album.rb')
require_relative('models/artist.rb')

Album.delete_all()
Artist.delete_all()

artist1 = Artist.new({'name' => 'Miley Cyrus'})
artist1.save()

album1 = Album.new({'title' => 'Time of our Lives', 'genre' => 'pop', 'artist_id' => artist1.id})
album1.save()

binding.pry
nil
