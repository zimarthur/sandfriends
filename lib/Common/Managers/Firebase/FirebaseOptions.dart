import 'package:sandfriends/Common/Providers/Environment/DeviceEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/FlavorEnum.dart';
import 'package:sandfriends/Common/Providers/Environment/ProductEnum.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

Map<Product, Map<Flavor, Map<Device, FirebaseOptions>>> firebaseOptions =
    const {
  Product.Sandfriends: {
    Flavor.Prod: {
      Device.Ios: FirebaseOptions(
        apiKey: 'AIzaSyDT0kQqFx2InNi3bVKsmN0NhkbqyXhFK-Q',
        appId: '1:329100803665:ios:da38d869a1e40dd9af4270',
        messagingSenderId: '329100803665',
        projectId: 'sandfriends-prod',
        storageBucket: 'sandfriends-prod.appspot.com',
        androidClientId:
            '329100803665-0l7lmmcdfoqkg0h9vjffqmsk79p4b531.apps.googleusercontent.com',
        iosClientId:
            '329100803665-n566cd89i1hki8agb7qit1at2odbhgmg.apps.googleusercontent.com',
        iosBundleId: 'com.sandfriends.app.prod',
      ),
      Device.Android: FirebaseOptions(
        apiKey: 'AIzaSyACNkmqOyYaCZKYyDuZRDpYp1weZrI3aqI',
        appId: '1:329100803665:android:8ead35e5e7c0d150af4270',
        messagingSenderId: '329100803665',
        projectId: 'sandfriends-prod',
        storageBucket: 'sandfriends-prod.appspot.com',
      ),
      Device.Web: FirebaseOptions(
        apiKey: 'AIzaSyBqB0l8u_ToZjzmXnlRD_bm7xyvGG6yhxw',
        appId: '1:329100803665:web:b0e6d8558c2dc6c3af4270',
        messagingSenderId: '329100803665',
        projectId: 'sandfriends-prod',
        authDomain: 'sandfriends-prod.firebaseapp.com',
        storageBucket: 'sandfriends-prod.appspot.com',
        measurementId: 'G-ELPPBT8PFZ',
      )
    },
    Flavor.Demo: {
      Device.Ios: FirebaseOptions(
        apiKey: 'AIzaSyByK42SdTckZPN4C6Pl0aqljbGWCAuy5wU',
        appId: '1:496096595246:ios:76948b490e30c73ddf7ebf',
        messagingSenderId: '496096595246',
        projectId: 'sandfriends-demo-1e87f',
        storageBucket: 'sandfriends-demo-1e87f.appspot.com',
        iosClientId:
            '496096595246-qeuclkgc0t3og75euhko0sm3blbelb23.apps.googleusercontent.com',
        iosBundleId: 'com.sandfriends.app.demo',
      ),
      Device.Android: FirebaseOptions(
        apiKey: 'AIzaSyA_XpefBCpokfQTZv-g5wMAdPsI2vEulLw',
        appId: '1:496096595246:android:b9d9225bb27a42badf7ebf',
        messagingSenderId: '496096595246',
        projectId: 'sandfriends-demo-1e87f',
        storageBucket: 'sandfriends-demo-1e87f.appspot.com',
      )
    },
    Flavor.Dev: {
      Device.Ios: FirebaseOptions(
        apiKey: 'AIzaSyB0h3Sj-AQD_trYOhunEHhHNK8CfvW4RtY',
        appId: '1:619166716922:ios:e92d69af68493f23fe4a43',
        messagingSenderId: '619166716922',
        projectId: 'sandfriends-dev',
        storageBucket: 'sandfriends-dev.appspot.com',
        iosClientId:
            '619166716922-5chc331o7huf8anq5cqnnqil5hqfr137.apps.googleusercontent.com',
        iosBundleId: 'com.sandfriends.app.dev',
      ),
      Device.Android: FirebaseOptions(
        apiKey: 'AIzaSyA5JAplCVAq1nigDWwrWQSEaXa-9NBw63c',
        appId: '1:619166716922:android:dc3c2122077ca134fe4a43',
        messagingSenderId: '619166716922',
        projectId: 'sandfriends-dev',
        storageBucket: 'sandfriends-dev.appspot.com',
      )
    }
  },
  Product.SandfriendsQuadras: {
    Flavor.Prod: {
      Device.Ios: FirebaseOptions(
        apiKey: 'AIzaSyDT0kQqFx2InNi3bVKsmN0NhkbqyXhFK-Q',
        appId: '1:329100803665:ios:9e329b79adc0e97caf4270',
        messagingSenderId: '329100803665',
        projectId: 'sandfriends-prod',
        storageBucket: 'sandfriends-prod.appspot.com',
        androidClientId:
            '329100803665-0l7lmmcdfoqkg0h9vjffqmsk79p4b531.apps.googleusercontent.com',
        iosClientId:
            '329100803665-bqlce4fk9ggfaunifvgkhflg9nkuv822.apps.googleusercontent.com',
        iosBundleId: 'com.sandfriends.quadras.prod',
      ),
      Device.Android: FirebaseOptions(
        apiKey: 'AIzaSyACNkmqOyYaCZKYyDuZRDpYp1weZrI3aqI',
        appId: '1:329100803665:android:1a81f3597ada3614af4270',
        messagingSenderId: '329100803665',
        projectId: 'sandfriends-prod',
        storageBucket: 'sandfriends-prod.appspot.com',
      )
    },
    Flavor.Demo: {
      Device.Ios: FirebaseOptions(
        apiKey: 'AIzaSyByK42SdTckZPN4C6Pl0aqljbGWCAuy5wU',
        appId: '1:496096595246:ios:161e757fb0a23858df7ebf',
        messagingSenderId: '496096595246',
        projectId: 'sandfriends-demo-1e87f',
        storageBucket: 'sandfriends-demo-1e87f.appspot.com',
        androidClientId:
            '496096595246-kg0drt0sqti3bolq927nbgq0g9c0m66o.apps.googleusercontent.com',
        iosClientId:
            '496096595246-67eqmoohovmo6krsibquothv2epo9jmd.apps.googleusercontent.com',
        iosBundleId: 'com.sandfriends.quadras.demo',
      ),
      Device.Android: FirebaseOptions(
        apiKey: 'AIzaSyA_XpefBCpokfQTZv-g5wMAdPsI2vEulLw',
        appId: '1:496096595246:android:1bb24b9a5a144be7df7ebf',
        messagingSenderId: '496096595246',
        projectId: 'sandfriends-demo-1e87f',
        storageBucket: 'sandfriends-demo-1e87f.appspot.com',
      )
    },
    Flavor.Dev: {
      Device.Ios: FirebaseOptions(
        apiKey: 'AIzaSyDFPRPoANMeMgVGCsHFMau1R-GOuXNiwuY',
        appId: '1:619166716922:ios:dbf1757f38c59769fe4a43',
        messagingSenderId: '619166716922',
        projectId: 'sandfriends-dev',
        storageBucket: 'sandfriends-dev.appspot.com',
        androidClientId:
            '619166716922-0qm315q4oia1vniu1lvpdtbc6takkupv.apps.googleusercontent.com',
        iosClientId:
            '619166716922-lqgavqhou4ngl4in1nk54nl09vhcminq.apps.googleusercontent.com',
        iosBundleId: 'com.sandfriends.quadras.dev',
      ),
      Device.Android: FirebaseOptions(
        apiKey: 'AIzaSyA5JAplCVAq1nigDWwrWQSEaXa-9NBw63c',
        appId: '1:619166716922:android:69ca61a11ee8ef4ffe4a43',
        messagingSenderId: '619166716922',
        projectId: 'sandfriends-dev',
        storageBucket: 'sandfriends-dev.appspot.com',
      )
    }
  }
};
