/*
Código originalmente desenvlvido Na Noite de Processing 
 de 26/02/2019, Code Jam: glifos e scripts gerativos.
 Aprimorado e comentado para a oficina "Uma outra prática de caligrafia",
 parte do evento Processing Community Day Brasil 2021
 */

PVector[][] alfabeto;

int largura, altura;
float mx, my;

float entrelinha = 1.5;

void setup() {
  size( 1200, 600 );

  //altura do caractere (pixels)
  altura = 100;
  //largura
  largura= altura;
  //margem x do texto -- margem da direita 
  mx = (width-(50*largura))*0.1;
  //margem y -- margem de baixo
  my = (height-(10*(1.5*altura)))*0.2;

  criaPontos();
  noLoop();
}

void draw() {
  background(255);

  noFill();
  stroke(#000000);
  strokeJoin(SQUARE);

  //neste bloco forma-se as linhas e determina-se quantos glifos cada linha terá
  //E então liga-se os pontos
  for ( int y = 0; y < 6; ++y ) {
    for ( int x = 0; x < 18; ++x ) {
      int numeroGlifo = sorteiaGlifo();
      if ( numeroGlifo >= 0 ) {
        translate(mx + x * largura, my + y*(entrelinha * altura));
        strokeWeight(1);
        line(0, 0, width, 0);
        line (0, altura*0.8, width, altura*0.8);
        stroke(255, 0, 0);
        point(0, 0);
        strokeWeight(8);
        ligarPontos(numeroGlifo);
        resetMatrix();
      }
    }
  }
}

void criaPontos() { 
  int quantidadeCaracteres = 25;//round( random( 3, 30 ) );
  int cjVertices = 7; //(2 * floor(random(2 , 5 ))) + 1; // tem que ser impar pq tem sempre 3 pontos, no mínimo pra fazer um traço
  float resVerticalGrid = 5;
  float resHorizontalGrid = 5;
  float resAltura = altura / resVerticalGrid; 
  float resHorizonte = largura / resHorizontalGrid;
  alfabeto = new PVector[ quantidadeCaracteres ][ cjVertices ]; 

  println("tem " + quantidadeCaracteres + " caracteres");
  println("o cj de vértices contem " + cjVertices);

  for ( int n = 0; n < alfabeto.length; ++n ) {
    boolean horizontal = (random(2) > 1)? true : false; 
    alfabeto[n][0] = new PVector( resHorizonte * floor (random(0, resHorizontalGrid)), resAltura * floor(random(0, resVerticalGrid)));

    for ( int i = 1; i < alfabeto[0].length; ++i ) {

      //este bloco sorteia a coordenada x do próximo ponto
      if ( horizontal ) {
        float novoX = alfabeto[n][i-1].x;
        while ( novoX == alfabeto[n][i-1].x ) novoX = resHorizonte * floor( random (0, resHorizontalGrid));
        alfabeto[n][i] = new PVector( novoX, alfabeto[n][i-1].y );
      }

      //este bloco sorteia a coordenada y do ponto
      else {
        float novoY = alfabeto[n][i-1].y;
        while ( novoY == alfabeto[n][i-1].y ) novoY = resAltura * floor( random (0, resVerticalGrid));
        alfabeto[n][i] = new PVector( alfabeto[n][i-1].x, novoY );
      }
      horizontal = !horizontal;
    }
  }
}

int sorteiaGlifo() {
  //sorteia o numero correspondente à posição de um glifo da lista na função criaPontos
  int glifo = round( random( -6.499, alfabeto.length-0.501 ) );
  return glifo;
}

void ligarPontos(int numero) {
  beginShape();
  vertex( alfabeto[numero][0].x, alfabeto[numero][0].y );
  stroke(60,9,90);
  for ( int i = 1; i < alfabeto[0].length; i += 2 ) {
    quadraticVertex( alfabeto[numero][i].x, alfabeto[numero][i].y, alfabeto[numero][i+1].x, alfabeto[numero][i+1].y );
  }
  endShape();
}

void keyReleased() {
  //Aperte espaço para escrever um novo texto
  if ( key == ' ' ) redraw();

  //Aperte P para salvar a imagem em png.
  else if ( key == 'p' || key == 'P' ) save("glifos "+year()+"-"+month()+"-"+day()+" "+hour()+"."+minute()+"."+second()+".jpg");

  //Aperte R para re-criar o alfabeto. 
  else if ( key == 'r' || key == 'R' ) {
    criaPontos();
    redraw();
  }
}
