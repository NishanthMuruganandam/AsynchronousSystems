package kmaru.jchord.image;

import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.Paint;
import java.awt.Shape;
import java.awt.geom.Arc2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

import kmaru.jchord.Chord;
import kmaru.jchord.ChordKey;
import kmaru.jchord.ChordNode;
import kmaru.jchord.Finger;
import kmaru.jchord.FingerTable;

public class Drawer {

	Chord chord;

	BufferedImage image;
	Graphics2D graphics;

	int margin = 50;
	int width = 512;
	int height = 512;

	int radius = width / 2;
	int cx = margin + radius;
	int cy = margin + radius;

	String font = "TimesRoman";
	FontMetrics fontMetrics;


	public Drawer(Chord chord) {
		this.chord = chord;
		image = new BufferedImage(width + margin * 2, height + margin * 2,
				BufferedImage.TYPE_INT_ARGB);
		graphics = image.createGraphics();

		Font font = new Font("TimesRoman", Font.BOLD, 12);
		graphics.setFont(font);
		fontMetrics = graphics.getFontMetrics();
	}

	public void drawChordRing() {
		graphics.setPaint(Color.GRAY);
		graphics.drawArc(margin, margin, width, height, 0, 360);
	}

	public void drawNodes() {
		graphics.setPaint(Color.RED);
		for (int i = 0; i < chord.size(); i++) {
			ChordNode node = chord.getSortedNode(i);
			drawNode(node);
		}
	}
	
	public void drawNode(ChordNode node) {
		graphics.setPaint(Color.RED);
		ChordKey key = node.getNodeKey();
		double angle = key.getAngle();

		int x = cx - 5 + (int) (radius * Math.sin(angle));
		int y = cy - 5 - (int) (radius * Math.cos(angle));
		Shape shape = new Arc2D.Double(x, y, 10, 10, 0, 360, Arc2D.CHORD);
		graphics.fill(shape);
	}
	
	public void drawKeyStrings() {
		graphics.setPaint(Color.BLUE);
		for (int i = 0; i < chord.size(); i++) {
			ChordNode node = chord.getSortedNode(i);
			drawKeyString(node);
		}
	}
	
	public void drawKeyString(ChordNode node) {
		ChordKey key = node.getNodeKey();
		double angle = key.getAngle();
		int x = cx + (int) ((radius+10) * Math.sin(angle));
		int y = cy - (int) ((radius+10) * Math.cos(angle));
		y += fontMetrics.getAscent();
		int strWidth = fontMetrics.stringWidth(key.toString());
		int strHeight = fontMetrics.getHeight();

		if (x >= cx && y >= cy) {
		}
		else if (x >= cx && y < cy) {
			y -= strHeight;
		}
		else if (x < cx && y >= cy) {
			x -= strWidth;
		}
		else if (x < cx && y < cy) {
			x -= strWidth;
			y -= strHeight;
		}
		graphics.drawString(key.toString(), x, y);
	}
	
	public void drawPredLines() {
		for (int i = 0; i < chord.size(); i++) {
			ChordNode node = chord.getSortedNode(i);
			ChordNode pred = node.getPredecessor();
			drawLine(Color.MAGENTA, node, pred);
		}
	}

	public void drawSuccLines() {
		for (int i = 0; i < chord.size(); i++) {
			ChordNode node = chord.getSortedNode(i);
			ChordNode succ = node.getSuccessor();
			drawLine(Color.PINK, node, succ);
		}
	}

	public void drawFingerTable(ChordNode node) {
		FingerTable fingerTable = node.getFingerTable();
		for (int i = 0; i < fingerTable.size(); i++) {
			Finger finger = fingerTable.getFinger(i);
			ChordNode fingerNode = finger.getNode();
			drawLine(Color.ORANGE, node, fingerNode);
		}
	}

	public void drawLine(Paint paint, ChordNode node1, ChordNode node2) {
		graphics.setPaint(paint);
		
		ChordKey key1 = node1.getNodeKey();
		double angle1 = key1.getAngle();
		
		ChordKey key2 = node2.getNodeKey();
		double angle2 = key2.getAngle();
		
		int x1 = cx + (int) (radius * Math.sin(angle1));
		int y1 = cy - (int) (radius * Math.cos(angle1));

		int x2 = cx + (int) (radius * Math.sin(angle2));
		int y2 = cy - (int) (radius * Math.cos(angle2));

		graphics.drawLine(x1, y1, x2, y2);
	}

	public void writeFile(String fileName) throws IOException {
		ImageIO.write(image, "PNG", new File(fileName));
	}

	public Chord getChord() {
		return chord;
	}

	public void setChord(Chord chord) {
		this.chord = chord;
	}

	public BufferedImage getImage() {
		return image;
	}

	public void setImage(BufferedImage image) {
		this.image = image;
	}

	public Graphics2D getGraphics() {
		return graphics;
	}

	public void setGraphics(Graphics2D graphics) {
		this.graphics = graphics;
	}

	public int getMargin() {
		return margin;
	}

	public void setMargin(int margin) {
		this.margin = margin;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public String getFont() {
		return font;
	}

	public void setFont(String font) {
		this.font = font;
	}
	
	
}
