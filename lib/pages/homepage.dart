import 'package:flutter/material.dart';
import 'package:pptm_4/models/clothes_model.dart';
import 'package:pptm_4/pages/add_clothes.dart';
import 'package:pptm_4/pages/clothes_detail.dart';
import 'package:pptm_4/pages/edit_clothes_page.dart';
import 'package:pptm_4/services/clothes_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<dynamic> _clothesFuture;

  @override
  void initState() {
    super.initState();
    _clothesFuture = ClothesApi.getClothes();
  }

  void _refreshData() {
    setState(() {
      _clothesFuture = ClothesApi.getClothes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clothes"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _clothesContainer(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddClothes()),
          ).then((_) => _refreshData());
        },
        tooltip: "Add Clothes",
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _clothesContainer() {
    return FutureBuilder(
      future: _clothesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          clothesModel response = clothesModel.fromJson(snapshot.data!);
          return _clothesList(context, response.data!);
        } else {
          return const Center(child: Text("No data found."));
        }
      },
    );
  }

  Widget _clothesList(BuildContext context, List<Data> data) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name ?? 'No Name',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text("Kategori: ${item.category ?? '-'}"),
              Text("Harga: Rp${item.price ?? 0}"),
              Text("Rating: ${item.rating?.toStringAsFixed(1) ?? '0.0'}"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ClothesDetailPage(id: item.id!),
                          ),
                        ).then((_) => _refreshData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Detail",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditClothesPage(id: item.id!),
                          ),
                        ).then((_) => _refreshData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Edit", style: TextStyle(fontSize: 13)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await ClothesApi.deleteClothes(item.id.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Data berhasil dihapus"),
                            ),
                          );
                          _refreshData();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Gagal menghapus data: $e")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        minimumSize: const Size(80, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
