import 'package:flutter/material.dart';
import 'package:pptm_4/models/clothes_detail_model.dart';
import 'package:pptm_4/pages/homepage.dart';
import 'package:pptm_4/services/clothes_service.dart';

class ClothesDetailPage extends StatelessWidget {
  final int id;

  const ClothesDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clothes"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _clothesDetailContainer(id),
      ),
    );
  }

  Widget _clothesDetailContainer(int id) {
    return FutureBuilder(
      future: ClothesApi.getClothesById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          // parsing json ke model
          final model = ClothesDetailModel.fromJson(snapshot.data!);
          final data = model.data!;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(data.name ?? "-", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Kategori: ${data.category ?? "-"}"),
                Text("Harga: Rp${data.price ?? 0}"),
                Text("Brand: ${data.brand ?? "-"}"),
                Text("Rating: ${data.rating ?? 0.0}"),
                Text("Stok: ${data.stock ?? 0}"),
                Text("Terjual: ${data.sold ?? 0}"),
                Text("Rilis Tahun: ${data.yearReleased ?? 0}"),
                Text("Material: ${data.material ?? "-"}"),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
                    },
                    child: const Text("Kembali"),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(child: Text("Tidak ada data."));
        }
      },
    );
  }
}
