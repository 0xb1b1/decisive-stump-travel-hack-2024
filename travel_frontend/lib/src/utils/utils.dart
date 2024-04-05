abstract class Utils {
  static String makeUpperStr(List<String> tags) =>
      tags.map((e) => e[0].toUpperCase() + e.substring(1)).toList().join(', ');

  static List<String> makeUpperList(List<String> tags) =>
      tags.map((e) => e[0].toUpperCase() + e.substring(1)).toList();
}
