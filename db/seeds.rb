


UserBaby.all.each do |baby|
  [
    'BCG (tuberculose)', 'Hépatite B - dose 1',
    'DTCaP-Hib-HB - dose 1', 'Pneumocoque - dose 1',
    'Méningocoque B - dose 1', 'Rotavirus - dose 1',
    'DTCaP-Hib-HB - dose 2', 'Pneumocoque - dose 2',
    'Méningocoque B - dose 2', 'Rotavirus - dose 2',
    'Méningocoque C - dose 1', 'DTCaP-Hib-HB - dose 3',
    'Pneumocoque - dose 3', 'ROR - dose 1',
    'Méningocoque C - dose 2', 'ROR - dose 2',
    'DTCaP - rappel 6 ans', 'DTCaP - rappel ado'
  ].each do |name|
    Vaccination.find_or_create_by!(user_baby: baby, name: name) do |v|
      v.status = false
    end
  end
end
puts 'OK : ' + Vaccination.count.to_s + ' vaccinations créées'
