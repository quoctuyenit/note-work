'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache-v20250930201538';

const RESOURCES = {".git/COMMIT_EDITMSG": "1a4a097e17ceee03ae7a8df9253ac51a",
".git/config": "e9e01aa0079367551394252d6827503c",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "f3905d49d59c9c3b80f8e3053da83c16",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "224e27b1746be459cd228369dc35ac1d",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "15efa3c4dc8c776e72b206c3a7649e66",
".git/logs/refs/heads/gh-pages": "c71502a7d302c3f10943420452739b4f",
".git/logs/refs/remotes/origin/gh-pages": "64f93295b73f92c0d7a22ac371bc5469",
".git/objects/02/1d4f3579879a4ac147edbbd8ac2d91e2bc7323": "9e9721befbee4797263ad5370cd904ff",
".git/objects/04/b2e55c01ed30705217bd5c76df9fd10f724424": "086805c642424dc878416e89b5cf0e46",
".git/objects/08/b8ba7a3224e77b7f84dbdf20c39a729368622b": "9501f10de4d000e9decb62e561d02763",
".git/objects/09/1122d46dd6e2f9f1a9e168438f139cceee21c1": "86c140cb0c27b740d2e7f9fb2e057a49",
".git/objects/0c/e2a23919bcd2af84b551b7305d6a98276d8855": "ffc103d6c1e01cf7f9b423915a648774",
".git/objects/11/9d73007c00b3b33d71c2cd01d634cfca0d9717": "4f8906a6cc33b3ca407bdf94acac3ec3",
".git/objects/12/59d8c9d0eb061821b70484cf6f2c003fc9e999": "23342c0346c94dfcf34e54c2ab899b7e",
".git/objects/12/86273356b85d0a14b67d658066ba8eed1d40ee": "12c3947d7a0c64f84467811737f29d2b",
".git/objects/17/568ad2fe7e7e42102dd4e717b96bb964331fe4": "e9712bbaa99fa5c6fd1d66d28e8fb9b5",
".git/objects/18/e4d99203b15e4370653b14748823f360e101a5": "10d7ff1766e81ab5fd030a2cf76de157",
".git/objects/1a/dfb0a879693d1e87b6b249c73bb9626d67fc9b": "fa0cf6a9319fda3aa7d13149f25f2a75",
".git/objects/1f/ffa3fe0a4ba2102f2f1fd82315ffef52c50283": "9498e293ae28b9a18876d94205fe09b0",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/22/e5c9f007ec3237204f71d8e169055433a7b08c": "41a6b7af8854a7c7b4de4763c2f3eca9",
".git/objects/27/15d17c38ad388abfe0b4716e70c75a0bc66ae6": "fd41160eaa0b56cc23ca06303ccc5a90",
".git/objects/29/89662cfacbd5a3923e87bf8af82ec9e9915096": "04a5973642b220682c4c337efbb9ae88",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/2c/67d7991273e9954e8495391fe2dddaf84dd15e": "dc10e7b34afde28f38c25a98204dcc36",
".git/objects/32/1416ceba36451b910fd1c1a2173fd5af43d1a5": "63b22bd5f145ac4838ba5404b60ff6a6",
".git/objects/38/0d2817ede3afed5da32e584b2545fd1024c2fb": "dc18056969e9d7e781ef300e6a0cbdc6",
".git/objects/39/bf90b1909e9531b05884d0771357530a80e916": "24106acdd40a313bf1bfd09ebb491f5f",
".git/objects/3a/bf18c41c58c933308c244a875bf383856e103e": "30790d31a35e3622fd7b3849c9bf1894",
".git/objects/3b/85c8cedb39283330b3b9fec948f54191cab179": "3f8e3fc1555f80d306431d68e7c63eb5",
".git/objects/3d/ab7aed2ca22395a9754eb089bb441603b77bd5": "589a7f9dddaa0c29ff9570f0806e8b7a",
".git/objects/42/064b7a48f74cb1e1956abd3fd3eaa0eabdcd42": "0de5a75a3c128014ebd01af5de60ab8e",
".git/objects/48/09cf6f96f1ea03629bd0a33b10a3585284f396": "8f383769bf0a63cf6f175d6064e53cd5",
".git/objects/49/168224f571bb881801dd61678ae2347a34c60e": "aafebe5bc0aa7a4b5aa119f507c77851",
".git/objects/49/79faa6a1fa0666d3a0f1fa7b3b8660af2c0e43": "c4cbb4d51f5679122cc179897569ad12",
".git/objects/4b/f7aec14a8155f860f643b05a0324eae3525389": "edb74693b845fee37bf606672332e81c",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/4e/cadbe89fcf0225acbcfc706910f1eb0c6393e1": "97e69179191dde2b262d45e50c3c896a",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/50/ea8162bbee763136e0c0670ba12ff6883c886b": "3f173289c2828c03b9f483343269b0e4",
".git/objects/51/3f6145e2716bbcfbe42cd5530f2891c3384bd0": "74ded01e1dd56dd573948b60ce6b5092",
".git/objects/53/ee52cc1a8c6883ba19b29115835de549080c8c": "ec53c27d715522acaaa28d78339fa60e",
".git/objects/55/545a04cb57f2e0ee34f4ec73888dc06754aead": "59f9bb2a924b33fb7615644e8d2a0ee5",
".git/objects/58/4cea6266dea32fd6557bf9e0ef0101daf5c30b": "5cc205c9fbdaa1be300adf8c3192cda0",
".git/objects/5f/d3f134beacae5d157d32b3be64c5257a8b44ec": "5f31b9f08e2d66af090e03b996109b9a",
".git/objects/62/3386098219b3d496bb7480d3809ccb9c2a06e7": "00be505edcefe9808e98de3efc057984",
".git/objects/62/6e828b28e1b2ca548f70a9aba7d56ba1b1a366": "340af3850806b77b405c364936d98ad2",
".git/objects/65/ad8ed10a5026582d892bcd5d36f11ffa576b66": "ca400552b372e06c59932c4a1780f96f",
".git/objects/67/41ac1693045a4bbb2dfe9be417bd029da098bd": "642d3e0779479654811a93fe164bacd4",
".git/objects/67/68a09b732540192f0c19e5a5ea6ba49644bee3": "ae6f95ed082a9b3c1d809f776e92720a",
".git/objects/69/2cbc33b4fb549562549ddc1c9b8d2e2e5a93e9": "d9e64ca409c1e65326d5390f1aa5ada4",
".git/objects/69/677380564afbc8c576b1ba5a428d26e54f9653": "7b5208a3ebe0aa7b9546d4c3e776302a",
".git/objects/6c/3dfd57e8c3026748e5c0438b709d607fec9f9b": "015aef7705b8ec77765cde4813d0d7ac",
".git/objects/6d/2972caafa8e36e29ad41e7e369154569a8005a": "30ad9815f855faf3bdbb22ab8d6932fa",
".git/objects/71/e976f015ce6a366f688ad6e11f559957523827": "21fccd7704b53aa284396c9487ed162a",
".git/objects/76/db0072a87bf655fb7a2d7433f2982a6c0c6ebf": "332c7deab1dfa1dbcd3bad9765b3caad",
".git/objects/77/363b8c2736df2c131ece0a140a7e8637c65c0b": "615f8ba46561a00f3b6ebe7b1bd24d90",
".git/objects/79/5ffd421168766c6ffe8690a1eb0a4297db4e0f": "273143979e8a8d06781e0063aaf0b453",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/7c/73ee132fe6973198e8a9f36bc61caf586e9ef8": "c5ce60b1ebe0268679bf3ed52fcaaa80",
".git/objects/7c/9dcc35e964f1bcd86fbbb50e86299678aca770": "06209f92f42d764def1a291ca82b01f1",
".git/objects/7d/93612f18f8e64254576906f1f8a2fbb16398cc": "ed152cdd3af871a305d97a33527d0975",
".git/objects/80/d6d2b3205a33888743835bef63d1e60ae8539f": "0957acec356c6f5e9597ac3425009a4d",
".git/objects/81/c237bf624eb216532247f1a3db8ca0304c3ad2": "b3c7d40bc7d00befe9d055e05c2e0e99",
".git/objects/84/45dddaa88318d680ed2b44f15c5577a8b5dcfc": "e779514823ea70eb1ef3911fc21ee277",
".git/objects/86/d111f09a93cccfa0011858c519a823e7dafef7": "9a15839a59b5f501fbf7b9824c4b6f84",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/368292a70675725b4d450fb31a7af7e7a2465c": "f772b016eabfd2336c517d3cfb18602d",
".git/objects/92/4a2bd640e3481ff066b53add03d17e52535dca": "e07105c7734d3bb3ed367d492f65d306",
".git/objects/92/8ae38334611d514181545ce5291efa66ba475f": "7ce8f5190935f0418b0bd8522e7e41fa",
".git/objects/97/5f2569aea11da0e069e0bb4c12150bd2add122": "0794d32ce73a994165b9e9faf8a423c7",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/9a/db564b1b058cf653e507d94180206f85320778": "296d015bbf6fb5ca11d7885d4c174ccc",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9e/26dfeeb6e641a33dae4961196235bdb965b21b": "304148c109fef2979ed83fbc7cd0b006",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/a5/fe9456cebb7ab4d60c3b76d7ba667f5d58d523": "de6416d91f7d7f9fdae18f56ddb73a15",
".git/objects/a7/34dddae8c5b8d94073e02b612dbed9be84780d": "2aae926143865f7e441d657bd42a9927",
".git/objects/a9/520471ab9077bfed4d12fdcab16dd0102fc5b0": "ff6765b401d2e005a5722c859528b2ef",
".git/objects/ab/e605ff69517ea93db30c4a2382260efa5573e0": "1234f27c48c5f79c88ccfafe159c5d8c",
".git/objects/ab/ede29c259c879b7200b88d546514b77de10479": "bbc408ffe3521327e0592918f8fe55da",
".git/objects/ad/a7880a84b0a0922b037a6d6b415d9116681b5e": "be99defac2491e81b494b3c22fab1fd1",
".git/objects/ad/eed369440439d2f1246b7fe8649a2c4e565a2f": "0d2af35cb6063ee34590a72ee34a7a5b",
".git/objects/af/4ad7c56588e90a698c6a92babefec7e8c7856d": "de229231221099e8317b7965c472cc29",
".git/objects/b4/087601638612512c73f01e3a0e21ec2f0f7eb5": "9f84bb4eb4f3a491c98a471cffacb0fa",
".git/objects/b5/68dfb963b2c0f1d5fde0bbe8e3cdf27bb1787c": "5ac6b6b077c43405232c84cb7fbf16b7",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/c83ca7445bf95434f53f45e3615c6be37a03a6": "9b018d8eb8219999af4391ba2209bdbc",
".git/objects/bb/bbacccd55a83040a8b455f15c00f7691ab8a4e": "82ea0e109928cad256e3f6f6c8076964",
".git/objects/be/1eeab842abc6e1e51e5a23cb6997686765466c": "5ed8454db65c48a6d7acc5ed06267ddd",
".git/objects/c1/abc3b027f798c93316438c6d5fe189af79848e": "955ee5170202488a9b8c3ec59480a25e",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/c7/9361b26b824c0a4a04f7c2a6d0316dcd224b8d": "4902bb25d6e34ba87579f1bb9a3b4f26",
".git/objects/c8/ce4872a67df55c17bebbfda162453f079fd972": "0ed8eece1b8b19bb44d5699a007b22f0",
".git/objects/c9/446005d75cfb47a15e94020160bc414ec55c8f": "c15386069c89f52f1f10e1f027f0ab30",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/cc/3b195a9716dee08abdef70cbe807891703150a": "a9a261d7b88f877bac3fbcf3398c92f6",
".git/objects/cf/4990d123a75331897ca5574ac97870ccd6a8ef": "1532d7eee04b656e7d529e526347523b",
".git/objects/cf/83fdd6da8ab4d37278fcce5d0508c51fdeb08c": "d0dfb61160a03e11e6c15cfec26adab0",
".git/objects/d0/29f474adef36b3154ac5261d550322bfe980b3": "693db265b19225f39ca54f92e0190d4e",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/dc/5e23de7382871c3d9cbc3a4f882e433d05ef07": "fc8fbb557e03dc8daf41e29908909220",
".git/objects/dc/c45c0c97e63e53b3aa04e64446132b14db948a": "86377f4ad9c6a576a557ef1566f6e843",
".git/objects/e0/499c50ee63164730899f2c2d37b3f0a536daa7": "a33ef332cfeb0ce13530c1a38dfe4151",
".git/objects/e3/663fe9946cc11492190b8c1ce0b4d87f3af56b": "cc493f354a797862aaddd66a7e112fee",
".git/objects/e3/e9ee754c75ae07cc3d19f9b8c1e656cc4946a1": "14066365125dcce5aec8eb1454f0d127",
".git/objects/e4/e5ae1bdacce9d44ebd62daf4975c9a1f37fd23": "7dac38422c36e6ebb4b98105614a3d1d",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/ee/328055ed963b69975a523ec6b2ecbd16a42423": "b9f148ef103b7aef4b8d413e2e2d5d9c",
".git/objects/f0/a60138406daf9eee6b17312833916e29c66a55": "32483b65eb9bc207abeac5913b12c938",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/88adb2c4fee9fee01a4fbfa9ce6b8af77af2ae": "4fa1c091cbb00f703b2acdcbeb293fc4",
".git/objects/f6/7493498458cf24267d11d551d79daa55710292": "448dfdbc8a31adcbf95698d46b80f713",
".git/objects/f8/85d14916d62c9bec43d6634f5ea0ceab8399ef": "8b8ba0d14bdf82d938fcde24def066ab",
".git/objects/fb/eeefdeabd1204b6008b79ed9fb1badc0bdd905": "d205b7eda89afadfabefea8c4ea23461",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/fe/c85f952b5fbfe41440a933f3a934b099aeed2f": "cb69bcf61189917ad96217a7f2159492",
".git/objects/pack/pack-3cfee459a683c9b0ab0f2b168863afb3306bb7d8.idx": "dd911259f40281458717061f1f5ebf64",
".git/objects/pack/pack-3cfee459a683c9b0ab0f2b168863afb3306bb7d8.pack": "5893292d3c812f97b36877bda92eaccf",
".git/objects/pack/pack-3cfee459a683c9b0ab0f2b168863afb3306bb7d8.rev": "f3f436fa6767490486d9c0ad7fd2222e",
".git/packed-refs": "a891e6bb26eb0d480aef486a7e8ea166",
".git/refs/heads/gh-pages": "1f2259fd8068c05fbb823a43bc0351a6",
".git/refs/remotes/origin/gh-pages": "1f2259fd8068c05fbb823a43bc0351a6",
"assets/AssetManifest.bin": "0b0a3415aad49b6e9bf965ff578614f9",
"assets/AssetManifest.bin.json": "a1fee2517bf598633e2f67fcf3e26c94",
"assets/AssetManifest.json": "99914b932bd37a50b983c5e7c90ae93b",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "f343f86e5843c560c02bf8bd5ec0f338",
"assets/NOTICES": "7b97ebabb32ff3ca48e9669f7bec47ac",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"drift_worker.js": "844f2832256fce71608904bd31b15ca8",
"favicon.png": "115110d18a1306d189c40239437eddbf",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "a39101fc3556adea3a8f4f71503c165a",
"icons/Icon-192.png": "93282f9a9c5034280768468297bba9ba",
"icons/Icon-512.png": "cfbd57a4cd91b1f3f2dec9722b44ae77",
"icons/Icon-maskable-192.png": "93282f9a9c5034280768468297bba9ba",
"icons/Icon-maskable-512.png": "cfbd57a4cd91b1f3f2dec9722b44ae77",
"index.html": "fe5690e28898ff1327bc7bc9f5d942a1",
"/": "fe5690e28898ff1327bc7bc9f5d942a1",
"main.dart.js": "eec09cfb1cfd9ce16f797fa2c5490c4e",
"manifest.json": "069dfdfb204c6a2555076dbfaf61c121",
"version.json": "44536bcaadf03970f16926c65b77d3dc"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
