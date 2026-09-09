# Changelog

Tots els canvis importants d'aquest projecte es documentaran en aquest fitxer.

Aquest projecte segueix el format de Keep a Changelog.

## [1.0.2] - 08-09-2026

### Added
- Apartat de Configuració, separat del perfil (abans compartia icona amb tancar sessió).
- Personalització de l'estanteria: color de fusta (que ara defineix tot el tema visual de l'app), estil de llums, decoracions de planta i estil de coberta -- són atributs públics del perfil, visibles pels altres usuaris.
- Decoracions de planta (rosella, cactus, azalea) a les estanteries destacades, amb selecció múltiple: es reparteixen entre els jocs quan n'hi ha molts, i no es repeteixen mai al mateix prestatge.
- Cobertes estil cartutx retro, activables/desactivables des de Configuració, pintades segons la plataforma del joc (o daurades si és un preferit).
- Pàgina amb totes les reviews d'un perfil (el resum només en mostrava 3).
- Es pot puntuar i escriure una ressenya en marcar un joc com a Abandonat, també des del diàleg d'afegir a la biblioteca (abans només des d'Editar joc).
- Es pot marcar un joc com a preferit i indicar-hi les hores jugades directament en afegir-lo com a Completat.

### Changed
- "Preferits" i l'estanteria fixada del perfil ja no tenen scroll horitzontal: ara omplen tot l'ample en una graella vertical, com la biblioteca d'Inici.
- Totes les estanteries mostren les cobertes tocant la lleixa de fusta, sense cap espai.

### Fixed
- La barra superior i la pàgina de notificacions no reflectien el color de fusta triat.
- Overflow del logotip a la barra superior en amples límit.
- Contrast baix de les reviews del perfil amb la fusta de bedoll (clara).
- Error 401 en tornar de Configuració si s'havia tancat la sessió des d'allà.

## [1.0.0] - 02-09-2026

### Added
- Connexió amb Supabase.
- Servei d'autenticació.
- Login amb email.
- Login amb nickname mitjançant Edge Function.
- Registre d'usuaris.
- Taula `profiles`.
- Connexió BDD IGDB
- Videojocs afegibles a la biblioteca.
- Pantalla per editar els videojocs.
- Efecte joc preferit.
- Banners i millora interfície.
- Part social afegida.

## [0.1.0] - 28-07-2026

### Added
- Primera versió funcional de GameShelf.
- Pantalla de login.
- Pantalla de registre.
- Navegació amb GoRouter.
- Integració amb Supabase Auth.
