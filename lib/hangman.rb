require 'json'

=begin 
  TODO LIST
    Créer la fonction de sauvegarde
    qui enregistre l'objet Game eu format JSON
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
  secret_word.gsub!("\r\n", "")
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
    @found_word = []
    (@secret_word.length).times { @found_word.push("_")}
    @@parties += 1
    @gameover = false
    # @good_tries = []
    @bad_tries = []
  end

  def get_game_nbr()
    @@parties
  end

  def display()
    puts "Player: #{@joueur.name}"
    puts "Partie: ##{self.get_game_nbr}"
    puts "Word:   #{@secret_word}"
    print "Found: #{@found_word}\n"
    print "Errors: #{@bad_tries}\n"
    # puts self.save
  end
  
  def new_try()
    puts "Nouvelle proposition ? (or save)"
  
  ###
  # MARQUE-PAGE
  ###

  # insérer le if qui va bien pour sauver

    propal = gets.chomp.to_s.upcase
    if propal.match?(/^[A-Z]{1}$/)
      puts " "
      return propal
    else 
      puts "INVALID"
      puts " "
      return false
    end
  end

  def check_try(a)
    if self.secret_word.include?(a)
      # @found_word.push(a)
      le_mot = secret_word.split(//)
      le_mot.each_with_index do |n, index|
        if n == a
          @found_word[index] = a
        end
      end
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
      if @secret_word == @found_word.join
        puts "YOU WIN"
        puts @secret_word
        @gameover = true
      end
    end
  end

  def get_hash()
    hash = {:partie => get_game_nbr(), :joueur => @joueur.name, :secret_word => @secret_word, :trouve => @found_word, :erreurs => @bad_tries}
    return hash
  end

  def save()
    mon_jeu = self.get_hash.to_json
    return mon_jeu
  end

end

# Creation du dictionnaire de jeu, à n'executer que lors de la 1ère partie
# create_dict("liste_francais.txt", "dico-fr.txt")

# Creation joueur 
joueur1 = Player.new("Mathieu")

# Démarrage de la partie + boucle multi parties
replay = true
until !replay do
  secret_word = gen_secret_word("dico.txt")
  game = Game.new(joueur1, secret_word)
  game.start()
  puts "Continuer ? (O/N)"
  suite = gets.chomp.to_s.upcase
  if suite == "N"
    replay = false
  end
end

