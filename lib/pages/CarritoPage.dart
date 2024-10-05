import 'package:flutter/material.dart';

class CarritoPage extends StatefulWidget {
  final List carrito;
  final Map<int, int> cantidades;

  CarritoPage({required this.carrito, required this.cantidades});

  @override
  _CarritoPageState createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: widget.carrito.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.carrito.length,
                    itemBuilder: (context, index) {
                      final producto = widget.carrito[index];
                      int cantidad =
                          widget.cantidades[producto['id_repuestos']] ?? 1;
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: producto['imagen'] != null
                                    ? Image.network(
                                        producto['imagen'],
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.image,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.2),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      producto['nombre'],
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                        'Descripción: ${producto['descripcion']}'),
                                    Text(
                                        'Precio unitario: \$${producto['precio']}'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  if (cantidad > 1) {
                                                    widget.cantidades[producto[
                                                            'id_repuestos']] =
                                                        cantidad - 1;
                                                  }
                                                });
                                              },
                                            ),
                                            Text('Cantidad: $cantidad',
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                setState(() {
                                                  widget.cantidades[producto[
                                                          'id_repuestos']] =
                                                      cantidad + 1;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Total: \$${(producto['precio'] * cantidad).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    widget.carrito.removeAt(index);
                                    widget.cantidades
                                        .remove(producto['id_repuestos']);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Sección de totales con mejor diseño
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total de productos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.shopping_bag, color: Colors.blue),
                              SizedBox(width: 10),
                              Text(
                                'Total de Productos:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${calcularTotalProductos()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),
                      // Total general
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.green),
                              SizedBox(width: 10),
                              Text(
                                'Total a Pagar:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '\$${calcularTotalGeneral().toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Botón de generar orden con más diseño
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Funcionalidad de generar orden aquí
                          },
                          icon: Icon(Icons.shopping_cart_checkout, size: 24),
                          label: Text(
                            'Generar Orden',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  int calcularTotalProductos() {
    int totalProductos = 0;
    widget.cantidades.forEach((key, cantidad) {
      totalProductos += cantidad;
    });
    return totalProductos;
  }

  double calcularTotalGeneral() {
    double total = 0;
    widget.carrito.forEach((producto) {
      int cantidad = widget.cantidades[producto['id_repuestos']] ?? 1;
      total += producto['precio'] * cantidad;
    });
    return total;
  }
}
