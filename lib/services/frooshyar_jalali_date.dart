/// Persian date utility placeholder for FrooshYar.
///
/// The final implementation will use a Jalali date package while keeping
/// database timestamps in standard epoch format.
class FrooshyarJalaliDate {
  static String format(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
