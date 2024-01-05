import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pemesanan Makanan dan Minuman',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 198, 219, 141),
        scaffoldBackgroundColor: Color(0xFFD8D3AD),
      ),
      home: MenuScreen(),
    );
  }
}

class TotalHargaWidget extends StatelessWidget {
  final double totalHarga;

  TotalHargaWidget({required this.totalHarga});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Total Harga: Rp ${totalHarga.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  final String image;
  final String category;

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItem> menuItems = [
    MenuItem(name: 'Makanan 1', price: 10, image: 'assets/mie_ayam.png', category: 'Makanan'),
    MenuItem(name: 'Makanan 2', price: 12, image: 'assets/nasi_goreng.png', category: 'Makanan'),
    MenuItem(name: 'Minuman 1', price: 5, image: 'assets/es_jeruk.png', category: 'Minuman'),
    MenuItem(name: 'Minuman 2', price: 4, image: 'assets/es_teh.png', category: 'Minuman'),
  ];

  Map<MenuItem, int> cartItems = {};
  double totalHarga = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemesanan Makanan dan Minuman'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(menuItems[index].image),
                  title: Text(menuItems[index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          removeFromCart(menuItems[index]);
                        },
                      ),
                      Text('${cartItems[menuItems[index]] ?? 0}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          addToCart(menuItems[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          TotalHargaWidget(totalHarga: totalHarga),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cartItems: cartItems, totalHarga: totalHarga),
                    ),
                  );
                },
                child: Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(MenuItem item) {
    setState(() {
      if (cartItems.containsKey(item)) {
        cartItems[item] = (cartItems[item] ?? 0) + 1;
      } else {
        cartItems[item] = 1;
      }
      totalHarga += item.price;
    });
  }

  void removeFromCart(MenuItem item) {
    setState(() {
      if (cartItems.containsKey(item)) {
        cartItems[item] = (cartItems[item] ?? 0) - 1;
        if (cartItems[item] == 0) {
          cartItems.remove(item);
        }
        totalHarga -= item.price;
      }
    });
  }
}

class CartScreen extends StatefulWidget {
  final Map<MenuItem, int> cartItems;
  final double totalHarga;

  CartScreen({required this.cartItems, required this.totalHarga});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String nama = '';
  String nomorBangku = '';
  String pesanKhusus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konfirmasi Pesanan'),
      ),
      body: Column(
        children: [
          TotalHargaWidget(totalHarga: widget.totalHarga),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Nama',
              ),
              onChanged: (value) {
                setState(() {
                  nama = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Nomor Bangku',
              ),
              onChanged: (value) {
                setState(() {
                  nomorBangku = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Pesan Khusus',
              ),
              onChanged: (value) {
                setState(() {
                  pesanKhusus = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                MenuItem menuItem = widget.cartItems.keys.elementAt(index);
                int quantity = widget.cartItems.values.elementAt(index);
                return ListTile(
                  leading: Image.asset(menuItem.image),
                  title: Text(menuItem.name),
                  subtitle: Text('Harga: Rp ${menuItem.price.toStringAsFixed(2)} x $quantity'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              _showConfirmationDialog(context);
            },
            child: Icon(Icons.check),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Pesanan'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pesanan atas nama: $nama'),
              Text('Nomor Bangku: $nomorBangku'),
              Text('Pesan Khusus: $pesanKhusus'),
              Text('Pesanan telah dikonfirmasi.'),
              Text('Silahkan tunggu :)'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
