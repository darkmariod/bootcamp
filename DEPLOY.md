# Despliegue de LawyerEC en un VPS con Dokploy

Guía paso a paso para poner LawyerEC en producción. La app ya viene lista:
Dockerfile de producción, PostgreSQL y PWA instalable. Sobre un solo VPS corre
con **un solo contenedor** (Puma) y **una sola base PostgreSQL** — sin worker
aparte ni bases extra.

---

## 0. Requisitos

- Un VPS (Hetzner, DigitalOcean, Contabo, etc.) con **Dokploy** instalado.
- Un dominio apuntando al VPS (recomendado, para HTTPS automático). Opcional al inicio.
- La **clave maestra**: el contenido de `config/master.key` (una sola línea).
  ⚠️ Nunca la subas al repositorio; se pasa como variable de entorno.

---

## 1. Base de datos PostgreSQL

En Dokploy: **Create → Database → PostgreSQL**.
- Anotá el nombre de la base, usuario y password.
- Dokploy te da una **connection URL** del tipo:
  `postgres://usuario:password@host:5432/lawyer_ec_production`
  Esa URL es tu `DATABASE_URL`.

No hace falta volumen para la base: Dokploy ya persiste el servicio Postgres.

---

## 2. La aplicación

En Dokploy: **Create → Application**.

**Opción A — desde Git (la más simple).** Conectá el repositorio; Dokploy detecta
el `Dockerfile` y construye la imagen en cada push.

**Opción B — imagen prearmada.** Si preferís construir vos la imagen:
```bash
docker build -t lawyerec .
docker tag lawyerec tu-usuario/lawyerec:latest
docker push tu-usuario/lawyerec:latest
```
y en Dokploy elegís esa imagen del registry.

### Variables de entorno (Environment)
```
RAILS_MASTER_KEY=<contenido de config/master.key>
DATABASE_URL=postgres://usuario:password@host:5432/lawyer_ec_production
APP_HOST=lawyerec.tudominio.com
FORCE_SSL=true
# Correo (opcional — sin esto la app anda pero no envía mails):
# SMTP_ADDRESS=smtp.tuproveedor.com
# SMTP_PORT=587
# SMTP_USERNAME=usuario
# SMTP_PASSWORD=password
```

> Mientras probás por `http://IP` sin dominio todavía, poné `FORCE_SSL=false`.
> Cuando tengas dominio + certificado, volvé a `true`.

### Puerto
El contenedor expone el **3000**. En Dokploy mapeás el dominio → puerto 3000.

### Volumen persistente (IMPORTANTE)
Los **documentos subidos a los casos** (Active Storage) se guardan en disco.
Montá un volumen para que no se borren en cada redeploy:

- **Mount path:** `/rails/storage`

La base es PostgreSQL, así que el volumen es SOLO para los archivos adjuntos.

---

## 3. Deploy

Presioná **Deploy**. Al arrancar, el contenedor corre `bin/docker-entrypoint`,
que ejecuta las **migraciones** automáticamente (`db:prepare`). No hay que hacer
nada manual para el esquema.

### Certificado HTTPS
Con el dominio configurado, Dokploy (Traefik) emite el certificado Let's Encrypt
solo. A partir de ahí `FORCE_SSL=true` funciona correctamente.

---

## 4. Primer usuario

La imagen NO carga datos de demo en producción. Creá el usuario administrador
desde la consola de la app en Dokploy (**Terminal** del contenedor):

```bash
bin/rails runner "User.create!(name: 'Administrador', email_address: 'admin@tudominio.com', password: 'una-clave-segura', role: 'admin')"
```

Desde ahí, ese admin crea el resto de usuarios en **Administración → Usuarios y roles**.

---

## 5. PWA (app instalable)

Ya está activada. En el navegador (Chrome/Edge/Safari móvil) aparece la opción
**"Instalar app" / "Agregar a pantalla de inicio"**. Se instala con el ícono y
nombre LawyerEC, y abre en modo pantalla completa. Requiere HTTPS (paso 3).

---

## Resumen de por qué es simple

| Componente        | En producción              |
|-------------------|----------------------------|
| Base de datos     | PostgreSQL (1 sola)        |
| Trabajos (correo) | En proceso (`async`)       |
| Caché             | En memoria                 |
| Web server        | Puma (1 contenedor)        |
| Archivos subidos  | Volumen en `/rails/storage`|
| Migraciones       | Automáticas al bootear     |

Si algún día necesitás jobs durables o alta concurrencia, se activa Solid Queue
con un proceso worker. Para un consorcio de abogados, esto sobra.
