import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomModalContent extends StatelessWidget {
  const CustomModalContent({
    super.key,
    required this.toMartosSchedule,
    required this.toJaenSchedule,
    required this.databaseName,
  });
  final List<dynamic> toMartosSchedule;
  final List<dynamic> toJaenSchedule;
  final String databaseName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (databaseName != 'martos')
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      toMartosSchedule.isNotEmpty
                          ? 'Próximas salidas sentido Martos'
                          : 'No hay más salidas hoy',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: toMartosSchedule.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          trailing: index == 0
                              ? IconButton(
                                  icon: const Icon(
                                    size: 24,
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  //TODO timer function in the first tile
                                  onPressed: () {},
                                )
                              : const SizedBox(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            toMartosSchedule[index].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        if (databaseName != 'jaen')
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      toJaenSchedule.isNotEmpty
                          ? 'Próximas salidas sentido Jaén'
                          : 'No hay más salidas hoy',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: toJaenSchedule.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          trailing: index == 0
                              ? IconButton(
                                  icon: const Icon(
                                    size: 24,
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                )
                              : const SizedBox(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            toJaenSchedule[index].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
