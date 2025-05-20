import 'package:flutter/material.dart';
import 'package:pptm_4/models/clothes_detail_model.dart';
import 'package:pptm_4/pages/homepage.dart';
import 'package:pptm_4/services/clothes_service.dart';

class EditClothesPage extends StatefulWidget {
  final int id;
  const EditClothesPage({super.key, required this.id});

  @override
  State<EditClothesPage> createState() => _EditClothesPageState();
}

class _EditClothesPageState extends State<EditClothesPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _sold = TextEditingController();
  final TextEditingController _rating = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _material = TextEditingController();

  ClothesDetailData? _clothesData;

  @override
  void initState() {
    super.initState();
    _fetchAndSetClothes();
  }

  Future<void> _fetchAndSetClothes() async {
  try {
    final response = await ClothesApi.getClothesById(widget.id);
    final parsed = ClothesDetailModel.fromJson(response);
    final data = parsed.data;

    if (data != null) {
      setState(() {
        _clothesData = data;
        _name.text = data.name ?? '';
        _price.text = data.price?.toString() ?? '';
        _category.text = data.category ?? '';
        _brand.text = data.brand ?? '';
        _sold.text = data.sold?.toString() ?? '';
        _rating.text = data.rating?.toString() ?? '';
        _stock.text = data.stock?.toString() ?? '';
        _year.text = data.yearReleased?.toString() ?? '';
        _material.text = data.material ?? '';
      });
    } else {
      throw Exception('Data kosong');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal mengambil data: $e")),
    );
  }
}


  Future<void> updateClothes(BuildContext context) async {
    if (_name.text.trim().isEmpty ||
        _price.text.trim().isEmpty ||
        _category.text.trim().isEmpty ||
        _brand.text.trim().isEmpty ||
        _sold.text.trim().isEmpty ||
        _rating.text.trim().isEmpty ||
        _stock.text.trim().isEmpty ||
        _year.text.trim().isEmpty ||
        _material.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi 😠")),
      );
      return;
    }

    ClothesDetailData newClothesEdit = ClothesDetailData(
      id: (widget.id),
      name: _name.text,
      price: int.parse(_price.text),
      category: _category.text,
      brand: _brand.text,
      sold: int.parse(_sold.text),
      rating: double.parse(_rating.text),
      stock: int.parse(_stock.text),
      yearReleased: int.parse(_year.text),
      material: _material.text,
    );

    try {
      await ClothesApi.editClothes(newClothesEdit, widget.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil mengedit data 👍")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Homepage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengedit data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Clothes"),
        centerTitle: true,
        leading: ElevatedButton(onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
        }, child: const Icon(Icons.arrow_back)),
      ),
      body:
          _clothesData == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Nama'),
                    ),
                    TextField(
                      controller: _price,
                      decoration: const InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _category,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                    ),
                    TextField(
                      controller: _brand,
                      decoration: const InputDecoration(labelText: 'Brand'),
                    ),
                    TextField(
                      controller: _sold,
                      decoration: const InputDecoration(labelText: 'Terjual'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _rating,
                      decoration: const InputDecoration(labelText: 'Rating'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _stock,
                      decoration: const InputDecoration(labelText: 'Stok'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _year,
                      decoration: const InputDecoration(labelText: 'Tahun'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _material,
                      decoration: const InputDecoration(labelText: 'Bahan'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => updateClothes(context),
                      child: const Text('Simpan Perubahan'),
                    ),
                  ],
                ),
              ),
    );
  }
}
