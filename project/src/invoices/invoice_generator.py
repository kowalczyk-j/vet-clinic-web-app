from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from datetime import datetime

pdfmetrics.registerFont(TTFont('FreeSans', "FreeSans.ttf"))
pdfmetrics.registerFont(TTFont('FreeSansBold', "FreeSansBold.ttf"))


def generate_unique_invoice_number():
    return datetime.now().strftime("%m%d%H%M%S")


def get_font_styles():
    styles = getSampleStyleSheet()
    heading_style = ParagraphStyle(
        'Heading1',
        parent=styles['Heading1'],
        fontName='FreeSansBold',
        fontSize=14,
        leading=16,
        encoding='utf-8',
    )
    normal_style = ParagraphStyle(
        'Normal',
        parent=styles['Normal'],
        fontName='FreeSans',
        fontSize=10,
        leading=12,
        encoding='utf-8',
    )
    return heading_style, normal_style


def get_table_style():
    return TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.lightgrey),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'FreeSans'),
        ('FONTSIZE', (0, 0), (-1, 0), 12),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('FONTNAME', (0, 1), (-1, -1), 'FreeSans'),
        ('FONTSIZE', (0, 1), (-1, -1), 10),
        ('LEADING', (0, 1), (-1, -1), 12),
        ('FONTENCODING', (0, 1), (-1, -1), 'utf-8'),
    ])


def prepare_invoice_content(invoice_data, invoice_number):
    heading_style, normal_style = get_font_styles()
    table_style = get_table_style()
    content = []
    content.append(Paragraph(f"Faktura VAT nr {invoice_number}", heading_style))
    content.append(Spacer(1, 20))

    # Dane firmy
    company_data = [
        ["Nazwa firmy:", "VetCare Sp. z o.o."],
        ["Adres:", "ul. Słoneczna 10, 00-024 Warszawa, POL"],
        ["NIP:", "5222961478"],
        ["tel.:", "742 293 292"],
    ]
    company_table = Table(company_data, colWidths=[80 * mm, None])
    company_table.setStyle(table_style)
    content.append(company_table)
    content.append(Spacer(1, 20))

    # Dane nabywcy
    content.append(Paragraph("Dane nabywcy:", heading_style))
    content.append(Paragraph(f"Imię i nazwisko: {invoice_data['nabywca']['imie_nazwisko']}", normal_style))
    content.append(Paragraph(f"Adres: {invoice_data['nabywca']['adres']} \n POL", normal_style))
    content.append(Paragraph("<b>NIP:</b> BRAK", normal_style))
    content.append(Spacer(1, 20))

    # Informacje dodatkowe
    content.append(Paragraph("Data sprzedaży: 2023-05-29", normal_style))
    content.append(Paragraph("Data płatności: 2023-05-29", normal_style))
    content.append(Paragraph("Sposób płatności: Karta", normal_style))
    content.append(Spacer(1, 20))

    # Pozycje faktury
    vat_rate = 8
    total_cost = 0
    content.append(Paragraph("Pozycje faktury:", heading_style))
    items = invoice_data['pozycje']
    item_data = [['Lp.', 'Nazwa towaru', 'VAT', 'Ilość', 'Cena netto', 'Cena brutto', 'Razem']]
    for i, item in enumerate(items, start=1):
        item_cost = item['cena_brutto']*item['ilosc']
        item_row = [
            str(i),
            item['opis'],
            f"{vat_rate}%",
            str(item['ilosc']),
            f"{(item['cena_brutto']/(1+vat_rate*0.01)):.2f} PLN".replace(".", ","),
            f"{item['cena_brutto']:.2f} PLN".replace(".", ","),
            f"{item_cost:.2f} PLN".replace(".", ","),
        ]
        total_cost += item_cost
        item_data.append(item_row)
    item_table = Table(item_data, colWidths=[20 * mm, None, 20 * mm, 20 * mm, 30 * mm, 30 * mm, 30 * mm])
    item_table.setStyle(table_style)
    content.append(item_table)
    content.append(Spacer(1, 20))

    # Podsumowanie
    content.append(Paragraph(f"Do zapłaty: {total_cost:.2f} PLN".replace(".", ","), heading_style))
    content.append(Spacer(1, 20))
    content.append(Paragraph(77 * "_", normal_style))
    return content


def generate_invoice_pdf(invoice_data):
    invoice_number = generate_unique_invoice_number()
    pdf = SimpleDocTemplate(f"Faktura_{invoice_number}.pdf", pagesize=A4)
    content = prepare_invoice_content(invoice_data, invoice_number)
    pdf.build(content)


# Przykładowe testowe dane faktury
invoice_data = {
    "nabywca": {
        "imie_nazwisko": "Jan Kowalski",
        "adres": "ul. Kwiatowa 5, 12-345 Warszawa",
    },
    "pozycje": [
        {
            "opis": "Konsultacja weterynaryjna",
            "ilosc": 1,
            "cena_brutto": 123.00,
            "wartosc": 123.00,
        },
        {
            "opis": "Badanie krwi",
            "vat": 8,
            "ilosc": 2,
            "cena_brutto": 54.00,
            "wartosc": 108.00,
        },
    ],
}

# TODO: usunąć wywołanie funkcji poniżej
if __name__ == "__main__":
    generate_invoice_pdf(invoice_data)
