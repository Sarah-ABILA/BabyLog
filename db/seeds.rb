# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "--- Nettoyage de la base de données ---"
# L'ordre est important à cause des dépendances (FK)
Result.destroy_all
Message.destroy_all
Chat.destroy_all
UserBaby.destroy_all
User.destroy_all

puts "--- Création de l'utilisateur test ---"
# On utilise find_or_create_by pour éviter les erreurs si tu relances le seed
test_user = User.create!(
  first_name: "Jean",
  last_name: "Dupont",
  email: "parent@example.com",
  password: "password123"
)

puts "--- Création des enfants (UserBaby) ---"

# Enfant 1 : Jade
# Note : On utilise bien UserBaby.create! et non User.create!
baby_jade = UserBaby.create!(
  user: test_user,
  name: "Jade",
  weight: 11.0,
  birth_date: Date.parse("16/02/2025"),
  doctor: "Dr. Martin",
  # Pour l'instant, on laisse l'avatar à nil ou une string vide si pas d'ActiveStorage
  avatar: "https://images.generated.photos/sxyoxTFPgImv_3jRPIec4fIDxCvef81H6WpG2TmuvbI/rs:fit:512:512/czM6Ly9pY29uczgu/Z3Bob3Rvcy1wcm9k/LnBob3Rvcy8wODIx/NjI0LmpwZw.jpg"
)

# Enfant 2 : Emma
baby_emma = UserBaby.create!(
  user: test_user,
  name: "Emma",
  birth_date: Date.today - 2.months,
  weight: 5.2,
  doctor: "Dr. House",
  avatar: "https://images.generated.photos/f7yUwjaF3tlNmsK8tBS-O4ZxBAbXvabguGYWfH35Qhw/rs:fit:512:512/czM6Ly9pY29uczgu/Z3Bob3Rvcy1wcm9k/LnBob3Rvcy8wMjQ2/MjgzLmpwZw.jpg"
)

puts "--- Création du Chat IA pour Jade ---"
chat_jade = Chat.create!(
  user: test_user,
  title: "Analyse sommeil de Jade",
  persona: "maman solo"
)

Message.create!([
  { chat: chat_jade, role: "user", content: "Jade se réveille souvent, est-ce lié à ses dents ?" },
  { chat: chat_jade, role: "assistant", content: "À son âge, les poussées dentaires sont une cause fréquente de réveil nocturne. Observez-vous un gonflement des gencives ?" }
])

Result.create!(
  chat: chat_jade,
  roadmap: "<p class='intro-text'>Voici un plan pour apaiser les nuits de Jade :</p><div class='step'><h2>Soulagement</h2><ul><li>Anneau de dentition froid</li><li>Massage des gencives</li></ul></div>"
)

puts "--- Seeding terminé avec succès ! ---"
puts "Identifiant : parent@example.com / password123"
