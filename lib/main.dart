import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // leer archivos de assets
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login y Galería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: GoogleFonts.oswaldTextTheme(
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/bienvenida': (context) => const BienvenidaPage(),
        '/galeria': (context) => const GaleriaPage(),
      },
    );
  }
}

//////////////// PANTALLA LOGIN /////////////////////////////
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Función que valida usuario/contraseña desde usuarios.txt
  Future<bool> _validarLogin(String usuario, String password) async {
    // Leer archivo de texto
    String contenido = await rootBundle.loadString('./usuarios.txt');

    // Separar en líneas
    List<String> lineas = contenido.split('\n');

    for (var linea in lineas) {
      linea = linea.trim();
      if (linea.isEmpty) continue;

      List<String> partes = linea.split(':');
      if (partes.length == 2) {
        String user = partes[0].trim();
        String pass = partes[1].trim();

        if (usuario == user && password == pass) {
          return true; // ✅ encontrado
        }
      }
    }
    return false; // ❌ no coincide
  }

 void _login() async {
  String usuario = _usuarioController.text.trim();
  String password = _passwordController.text.trim();

  bool acceso = await _validarLogin(usuario, password);

  if (!mounted) return; // evita error si el widget ya no existe

  if (acceso) {
    Navigator.pushNamed(context, '/bienvenida', arguments: usuario);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Espabila que esa no es...")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "INICIAR SESION",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 300,//ancho fijo,
                child: TextField(
                  controller: _usuarioController, //controla el usuario
                  decoration: InputDecoration(
                    labelText: 'Usuario...',
                    border: OutlineInputBorder()
                  ),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _passwordController, //controla a contrase;a
                  obscureText: true,//oculta contrase;a
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder()
                  ) ,
                ),
              ),
              
              const SizedBox(height: 20),
              ElevatedButton(
                
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Acceder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
////////////////// PANTALLA DE BIENVENIDO /////////////////////////
class BienvenidaPage extends StatelessWidget {
  const BienvenidaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String usuario = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenido a ElDelPade"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono con borde circular
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 222, 33, 243),
                  width: 4,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_tennis,
                size: 100,
                color: const Color.fromARGB(255, 243, 33, 243),
              ),
            ),
            const SizedBox(height: 40),
            
            // Mensaje de bienvenida
            Text(
              "👋 Bienvenido, $usuario",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 20),
            
            // Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Esta es la página principal de Nani, profe de la escuela NorbaPadel. Aquí te dejamos una galería con algunas de sus fotos y sus logos.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            
            // Botón para ir a la galería
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/galeria');
              },
              icon: Icon(Icons.photo_library),
              label: const Text("Ir a foticos chulas"),
            ),
          ],
        ),
      ),
    );
  }
}

////////////// PANTALLA GALERÍA  ///////////////////
class GaleriaPage extends StatelessWidget {
  const GaleriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imagenes = [
      'assets/images/yo4.jpeg',
      'assets/images/yo2.jpeg',
      'assets/images/yo3.jpeg',
      'assets/images/yo1.jpeg',
      'assets/images/yo5.jpeg',
      'assets/images/yo6.jpeg',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Galería de ElDelPade")),
      body: GridView.builder(
        padding: const EdgeInsets.all(30), // Más espacio alrededor
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columnas
          crossAxisSpacing: 40, // Espacio horizontal entre imágenes
          mainAxisSpacing: 40,  // Espacio vertical entre imágenes
        ),
        itemCount: imagenes.length,
        itemBuilder: (context, index) {
          return ImagenConHover(url: imagenes[index]);
        },
      ),
    );
  }
}

// Widget personalizado para el efecto hover
class ImagenConHover extends StatefulWidget {
  final String url;
  
  const ImagenConHover({super.key, required this.url});

  @override
  State<ImagenConHover> createState() => _ImagenConHoverState();
}

class _ImagenConHoverState extends State<ImagenConHover> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.0 : 0.8), // Aumenta 10% al pasar el cursor
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
