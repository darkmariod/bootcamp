# 🎉 Control de Finanzas — Listo para Usar

## ✅ Lo que está completado

- **Fase 1**: Base del proyecto (Docker + Rails + Tailwind + Hotwire)
- **Fase 2**: Autenticación con Devise (multi-usuario, scoping)
- **Fase 3**: Categorías + Seed con tus datos del Excel
- **Fase 4**: CRUD Gastos e Ingresos (transacciones)
- **Fase 5**: Clientes con fichas de resumen
- **Fase 6**: Facturas (crear, editar, estado)
- **PWA**: Instalable en iPhone (home screen + offline support)

---

## 🚀 Cómo levantar la app

```bash
docker compose up -d
```

La app estará en: **http://localhost:3001**

---

## 📱 Instalación en iPhone (Safari)

### Paso 1: Acceder desde el navegador
1. Abrí Safari en tu iPhone
2. Entrá a: `http://[tu-ip-local]:3001`
   - Para saber tu IP, corrés en la terminal: `ipconfig getifaddr en0`
   - Ej: `http://192.168.1.100:3001`

### Paso 2: Agregar a la pantalla de inicio
1. Tocá el ícono de **Compartir** (abajo al centro)
2. Scrolleá y tocá **"Agregar a pantalla de inicio"**
3. Dale un nombre (ej: "Finanzas") y tocá **Agregar**

### Resultado
- La app aparece como un ícono en tu home
- Se abre a pantalla completa (sin navegador)
- Funciona offline (con datos cacheados)
- Tema oscuro/claro automático según preferencia del iPhone

---

## 👤 Acceso inicial

**Email**: `test@finanzas.com`  
**Contraseña**: `password123`

O crea una cuenta nueva tocando "¿No tenés cuenta? Registrate"

---

## 🎯 Funcionalidades

### Inicio
- Resumen de ingresos, egresos y saldo del mes
- Últimas 5 transacciones

### Gastos e Ingresos
- ➕ Registrar gasto/ingreso
- Categorías (desde tu Excel): Sueldo, Alquiler, Salud Mental, Netflix, etc.
- Asociar a clientes (opcional)
- Editar/Eliminar transacciones

### Facturas
- ➕ Crear facturas
- Estados: Pendiente, Pagada, Vencida
- Asociar a clientes
- Ver historial

### Clientes
- Crear clientes
- Ver totales facturado, pendiente, ingresos, gastos por cliente
- Historial de facturas y transacciones

### Tema
- Botón sol/luna en el header
- Preferencia guardada en tu navegador
- Automático según iPhone oscuro/claro

---

## 🛠️ Comandos útiles

```bash
# Ver logs en vivo
docker compose logs -f web

# Acceder a Rails console (para debugging)
docker compose exec web bin/rails c

# Ver migraciones ejecutadas
docker compose exec web bin/rails db:version

# Reiniciar todo
docker compose restart web

# Parar
docker compose down
```

---

## 📊 Tu modelo de datos

### Categories (desde tu Excel)
- **INGRESOS FIJOS**: Sueldo, Freelance
- **EGRESOS NECESARIOS**: Alquiler, Servicios, Teléfono
- **EGRESOS PERSONALES**: Salud Mental, Comida, Transporte, Netflix, Spotify
- **EGRESOS COMPRAS**: Ropa, Tecnología, Libros, Casa
- **OTROS EGRESOS**: Perros, Videojuegos, Música, Cine
- **EGRESOS VIAJE**: Vuelos, Hospedaje, Tours

### Transactions
- Descripción
- Monto
- Fecha
- Tipo: Ingreso / Gasto Personal / Gasto Cliente
- Categoría (obligatoria)
- Cliente (opcional)

### Clients
- Nombre
- Email
- Teléfono
- Historial de facturas y transacciones

### Invoices
- Descripción
- Monto
- Fecha de emisión
- Estado (Pendiente/Pagada/Vencida)
- Cliente

---

## 🔒 Seguridad

- Cada usuario ve SOLO sus datos
- Devise maneja encriptación de contraseñas
- PostgreSQL en Docker (datos locales)
- CSRF protection activado

---

## 📝 Próximas mejoras (opcional)

- [ ] Reportes avanzados (gráficos mensuales)
- [ ] Exportar a Excel/PDF
- [ ] Recordatorios de facturas vencidas
- [ ] Estadísticas por categoría
- [ ] Dark/Light mode selector en UI
- [ ] Multi-lenguaje

---

**¿Preguntas?** Todos los archivos están listos para editar.  
**Stack**: Rails 7.1 + PostgreSQL + Tailwind + Hotwire + PWA

¡Disfruta! 🚀
