#!/usr/bin/env ruby
# Script para agregar PigeonApi.swift al target de Xcode automáticamente
# Requiere: gem install xcodeproj
# Uso: ruby scripts/add_pigeon_to_xcode.rb

require 'xcodeproj'

project_path = File.join(__dir__, '..', 'ios', 'Runner.xcodeproj')
project = Xcodeproj::Project.open(project_path)

# Buscar el target Runner
target = project.targets.find { |t| t.name == 'Runner' }
unless target
  puts "❌ Error: No se encontró el target 'Runner'"
  exit 1
end

# Buscar el grupo Runner
main_group = project.main_group
runner_group = main_group['Runner'] || main_group

# Buscar el archivo PigeonApi.swift
pigeon_file_path = File.join(__dir__, '..', 'ios', 'Runner', 'PigeonApi.swift')

unless File.exist?(pigeon_file_path)
  puts "❌ Error: No se encontró PigeonApi.swift en #{pigeon_file_path}"
  puts "💡 Ejecuta primero: flutter pub run pigeon --input pigeon/api.dart"
  exit 1
end

# Verificar si el archivo ya está en el proyecto
file_ref = runner_group.files.find { |f| f.path == 'PigeonApi.swift' }

if file_ref.nil?
  # Agregar el archivo al proyecto
  file_ref = runner_group.new_file('PigeonApi.swift')
  puts "✅ Archivo PigeonApi.swift agregado al proyecto"
else
  puts "ℹ️  Archivo PigeonApi.swift ya existe en el proyecto"
end

# Agregar al target si no está ya agregado
unless target.source_build_phase.files.find { |f| f.file_ref == file_ref }
  target.add_file_references([file_ref])
  puts "✅ Archivo agregado al target 'Runner'"
else
  puts "ℹ️  Archivo ya está en el target 'Runner'"
end

# Guardar el proyecto
project.save
puts "✅ Proyecto guardado exitosamente"
puts ""
puts "🎉 PigeonApi.swift está ahora configurado en Xcode"
puts "💡 Puedes descomentar el código en AppDelegate.swift"
