=begin 
  ouvrir 5desk.txt
  créer dico.txt avec les mots yaant entre 5 et 12 caractères
  sauvegarder dico.txt
=end

# création du dictionnaire des mots de 5 à 12 caractères
def create_dict(source, output)
  # source = "5desk.txt"
  # output = "dico.txt"
  source = source
  output = output
  dico = File.open(output, 'w')
  words = File.readlines source
  words.each do |word|
    if word.length > 6 && word.length < 15  # il doit y avoir un \n qui compte pour 2 à la fin de chaque ligne
      dico.puts "#{word}"
    end
  end
end

# Choix aléatoire du mot secret
def gen_secret_word(source)
  dico = File.open(source, 'r')
  # puts dico.readlines.size
  nb_words = File.readlines(dico).size  # 52453
  rdm = rand(0..nb_words)
  # puts rdm
  secret_word = File.readlines(dico)[rdm].upcase
  return secret_word  
end

# Créer des joueurs
class Player
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

# Créer des parties
class Game
  attr_reader :joueur, :secret_word
  @@parties = 0

  def initialize(joueur, secret_word)
    @joueur = joueur
    @secret_word = secret_word
    @@parties += 1
    @gameover = false
    @good_tries = []
    @bad_tries = []
  end

  def get_game_nbr()
    @@parties
  end

  def display()
    puts "Player: #{@joueur.name}"
    puts "Partie: ##{self.get_game_nbr}"
    puts "Word:   #{@secret_word}"
    print "Found: #{@good_tries}\n"
    print "Errors: #{@bad_tries}\n"
  end
  
  def new_try()
    puts "Nouvelle proposition ?"
    propal = gets.chomp.to_s.upcase
    if propal.match?(/^[A-Z]{1}$/)
      return propal
      # puts propal
    else 
      return false
    end
  end

  def check_try(a)
    if self.secret_word.include?(a)
      @good_tries.push(a)
    else
      @bad_tries.push(a)
    end
  end
  
  def start()
    until @gameover do
      self.display()
      a = self.new_try()
      if a
        check_try(a)
      end
    end
  end

end


# create_dict("liste_francais.txt", "dico-fr.txt") # utilisé la 1ere fois pour générer le dico
secret_word = gen_secret_word("dico.txt")
# puts secret_word

joueur1 = Player.new("Mathieu")
# joueur2 = Player.new("Caro")
# puts joueur1.name

game = Game.new(joueur1, secret_word)
# game.display()
game.start()