import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mdb/controller/userController.dart';
import 'package:geolocator/geolocator.dart';


class MapsPage extends StatefulWidget{
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}


class _MapsPageState extends State<MapsPage> {

  late GoogleMapController mapController;

  final _center = const LatLng(-5.147401178834754, -42.780008361506596);

  void _onMapCreated(GoogleMapController controller) => mapController = controller;


  Future<Uint8List> _generateIcon() async {
    ByteData image = await rootBundle.load('images/800px-Instituto_Federal_do_Piauí_-_Marca_Vertical_2015.svg.png');
    Uint8List icon = image.buffer.asUint8List();
    
    Uint8List finalIcon = await FlutterImageCompress.compressWithList(
      icon,
      minHeight: 110,
      minWidth: 110,
      quality: 90,
      format: CompressFormat.png
    );
    return finalIcon;
  }


  _localizacaoAtual() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


  Set<Marker> _marcadores = {};

  _carregarMarcadores() async{

    Uint8List finalIcon = await _generateIcon();

    List<Map<String, dynamic>> usuarios = await UserController().getAllUsers();
    
    Set<Marker> marcadorLocal = {};
    

    for(var usuario in usuarios){

      double lat = usuario['latitude'];
      double long = usuario['longitude'];

      Marker marcador = Marker(
        markerId: MarkerId(usuario["nome"]),
        position: LatLng(lat,long),
        icon: BitmapDescriptor.fromBytes(finalIcon),
        infoWindow: InfoWindow(title: usuario['nome'], onTap: (){
          showDialog(
            context: context, 
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Informações do ${usuario["nome"]}'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Email: ${usuario["email"]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text('Latitude: $lat', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text('Longitude: $long', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ],
                ),

                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar'))
                ],
              );
            });

        })
      );
      marcadorLocal.add(marcador);
      
    }

    setState(() {
      _marcadores = marcadorLocal;
    });
    
  }

  @override
  void initState() {
    super.initState();
    _localizacaoAtual();
    _carregarMarcadores();
    
  }
  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        centerTitle: true,
      ),

      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        markers: _marcadores,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0
        )
      ),
    );
    
  }
}