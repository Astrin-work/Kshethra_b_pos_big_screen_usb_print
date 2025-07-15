import 'package:flutter/material.dart';

class CategorySelectorWidget extends StatelessWidget {
  final List<String> categoryList;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategorySelectorWidget({
    super.key,
    required this.categoryList,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      color: const Color(0xFFFBEDE6),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orangeAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  categoryList[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
