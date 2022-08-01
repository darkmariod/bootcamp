# Cody

Un clon de Reddit con casi todas las funciones construido con Ruby on Rails, la aplicación es el resultado del bootcamp en [codigofacilito.com](https://codigofacilito.com/)

## Objetivo

En la aplicación, cada modelo será responsable de diferentes datos.

- El usuario es el autor. Tiene diferentes medios (texto, imagen/vídeo, enlace)
- Comunidad - Categoría basada en los envíos
- Comentarios - Una respuesta dada a la presentación de otro usuario a un usuario determinado.
- Suscripción - No debe confundirse con la facturación. Un usuario puede suscribirse y darse de baja de una comunidad.

## Requisitos funcionales

- Que sea un proyecto ejecutándose en un entorno de producción: Heroku, DigitalOcean.
- Que tenga al menos 3 tablas (modelos).
- Que exista relación entre estos recursos.
- Que implemente al menos un catálogo CRUD.
- Que la implementación prefiera usar convenciones de Rails. (Ejemplo no usar <form> si no helper methods.
- Que implemente trabajos en segundo plano, ejemplo con un mailer, o una actualización en segundo plano.
- Que implemente autenticación y autorización.
- Preferir usar REST en el diseño de rutas.
- Usar ActiveStorage

## Requisitos no funcionales
  
- Que use TURBO o Hotwire.
- Que implemente algún framework CSS.
- Que implemente actualizaciones en tiempo real.
- Que implemente pruebas unitarias

## Dependencias (Requisitos de ejecución)

- Git, para clonar el proyecto, instalar según el sistema operativo (o descargar como ZIP)
- Ruby 3.0.2, puede ser instalado con RVM, Chruby, RBenv, o nativo
- Gema bundler: gem install bundler

## Instalación

- Clonar el proyecto: git clone https://github.com/darthdmario/bootcamp.git
- Instalar las gemas bundle install
- Crear la base de datos: rails db:create db:migrate
- [Opcional] Popular la base de datos con los datos de pruena: rails db:seed
- Prender el servidor de prueba rails server
- Abrir el navegador en localhost:3000
- [Opcional] Para borrar la db en caso de querer volver a empezar rails db:drop

## Mejoras futuras

- La suscripción realizar tanto en Stipe,  PayPal para que pueda tener más suscriptores
- El seo, rutas, idioma de la aplicación  
