import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri policyUrl = Uri.parse(
    'https://celestial-clam-8a3.notion.site/a5c323e0053d4bda88a1584a2f941fce');

final Uri ruleUrl = Uri.parse(
    'https://celestial-clam-8a3.notion.site/d5d75deaea7d442293b4d3eb75868a02');

final Uri helpUrl = Uri.parse(
    'https://celestial-clam-8a3.notion.site/AIChats-4294b075a76341d8955ec3374aa5f8db');

void shareApp() async {
  await Share.share('AIChatsアプリで最先端AIと会話しよう！人工知能の力で日常をこれまで以上に便利に楽しくしませんか？');
}

Future<void> launchPolicyUrl() async {
  if (!await launchUrl(policyUrl)) {
    throw Exception('無効なURLです。');
  }
}

Future<void> launchRuleUrl() async {
  if (!await launchUrl(ruleUrl)) {
    throw Exception('無効なURLです。');
  }
}

Future<void> launchHelpUrl() async {
  if (!await launchUrl(helpUrl)) {
    throw Exception('無効なURLです。');
  }
}
