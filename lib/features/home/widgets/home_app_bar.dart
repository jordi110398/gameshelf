import 'package:flutter/material.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/features/search/search_page.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onLibraryChanged;

  const HomeAppBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onLibraryChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,

      // LOGO + NOM
      leadingWidth: isMobile ? 82 : 150,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports_esports,
              color: Colors.deepPurple,
              size: isMobile ? 22 : 28,
            ),
            const SizedBox(width: 6),
            Text(
              isMobile ? "GS" : "GameShelf",
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // CERCADOR REALMENT CENTRAT
      title: SizedBox(
        width: isMobile ? 200 : 400,
        height: 40,
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: isMobile ? "Buscar a la biblio..." : "Buscar a la biblioteca...",
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 8,
            ),
          ),
        ),
      ),

      // ACCIONS
      actions: [
        Container(
          width: isMobile ? 38 : 42,
          height: isMobile ? 38 : 42,
          margin: EdgeInsets.only(right: isMobile ? 2 : 8),
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: "Afegir joc",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );

              onLibraryChanged();
            },
          ),
        ),

        PopupMenuButton<String>(
          tooltip: "Més opcions",
          onSelected: (value) async {
            if (value == "logout") {
              await AuthService().signOut();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 12),
                  Text("Tancar sessió"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
