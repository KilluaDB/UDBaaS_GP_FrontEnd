
import 'package:dbaas_project/features/home/data/tabs.dart';

class HomeViewModel {
  List<Map<String, String>> tabs = Tabs().tabsData ;
    List<Map<String, String>> get tabsList=>
 tabs;
    
}