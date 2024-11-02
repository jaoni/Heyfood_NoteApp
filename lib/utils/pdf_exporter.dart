
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/note.dart';

class PdfExporter {
  static Future<void> exportNoteAsPdf(Note note) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(note.title, style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.Text("Created: ${note.createdAt}"),
            pw.Text("Last Modified: ${note.lastModified}"),
            pw.SizedBox(height: 20),
            pw.Text(note.content),
          ],
        ),
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: '${note.title}.pdf');
  }
}
