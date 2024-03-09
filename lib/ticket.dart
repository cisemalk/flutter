class Ticket {
  final String from;
  final String to;
  final String departureDate;
  final String returnDate;
  final String nofSeats;
  final String price;

  Ticket({
    required this.from,
    required this.to,
    required this.departureDate,
    required this.returnDate,
    required this.nofSeats,
    required this.price,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      from: json['From'],
      to: json['To'],
      departureDate: json['Departuredate'],
      returnDate: json['Returndate'],
      nofSeats: json['NofSeats'],
      price: json['Price'],
    );
  }
}