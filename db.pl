%----------------- DEFINES ----------------
%Sao Paulo.

voo(sao_paulo, mexico, h32, 02:35, (dia_chegada,8:14), 0, tam, [seg, ter, qua, qui, sex]).
voo(sao_paulo, nova_york, k312, 22:00, (dia_chegada,7:43), 0, gol, [seg, ter, qua, qui, sex]).
voo(sao_paulo, lisboa, h53, 07:00, (dia_chegada,1100), 0, azul, [seg, ter, qua, qui, sex]).
voo(sao_paulo, madrid, j76, 09:00, (dia_chegada,17:56), 0, tam, [seg, ter, qua, qui, sex]).
voo(sao_paulo, londres, i84, 16:00, (dia_chegada,20:12), 0, gol, [seg, ter, qua, qui, sex]).
voo(sao_paulo, paris, n76, 21:00, (dia_chegada,23:45), 0, azul, [seg, ter, qua, qui, sex]).

%Mexico.
voo(mexico, nova_york, g84 ,10:00,(dia_chegada,12:15), 0, azul,[ter,qui]).
voo(mexico, madrid, y69,17:45,(dia_chegada,23:50), 0, gol,[ter,qua,qui]).

%Nova York

voo(nova_york, londres, s32,14:34,(dia_chegada,19:32), 0, tam,[sex, sab, dom]).

%londres

voo(londres, lisboa, k76,13:20,(dia_chegada,16:13), 0, gol,[ter,qua]).
voo(londres, paris, i32,12:45,(dia_chegada,14:50), 0, azul,[qui,sex]).
voo(londres, estocolmo, s89,11:54,(dia_chegada,15:39), 0, tam,[sab]).

%madrid

voo(madrid, paris, l389,2:21,(dia_chegada,4:32), 0, gol,[dias]).
voo(madrid, roma, n731,5:74,(dia_chegada,9:12), 0, azul,[dias]).
voo(madrid, frankfurt, k6666, 9:23,(dia_chegada,14:47), 0, tam,[dias]).

%frankfurt

voo(frankfurt, estocolmo, t83, 21:55,(dia_chegada,23:55), 0, gol,[seg]).
voo(frankfurt, roma, b73 ,8:12,(dia_chegada,10:43), 0, azul,[ter]).





%----------------- FUNÇÕES ----------------
%voo(origem,destino,código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

	conc([], L, L).
	conc([X|L1], L2, [X|L]):-
		conc(L1, L2, L).

	pertence(X, [X|_]).
	pertence(X, [_|Cauda]):-
		pertence(X, Cauda).



% 1- (1 ponto) Verificar se eh possivel ir de uma cidade a outra sem escalas   ####### DONE ########
%?- vôo_direto(Origem, Destino, Companhia, Dia, Horário).

	voo_direto(Origem, Destino, Companhia, Dia, Horario):-
		voo(Origem, Destino, _, Horario, _, 0, Companhia, Dia).

% 2-	(1,5 pontos) É possível viajar de uma cidade X a outra Y, ainda que seja necessário fazer conexões? Independente do tempo da conexão (poderia ser de até uma semana). A sua função deve retornar a lista códigos de vôos que serão realizados.
% ####### DONE ########
	roteiro(Origem, Destino, ListaVoos) :-
		voo(Origem, Destino, Cod, _, _, 0, _, _),
		conc([], Cod, ListaVoos).

	roteiro(Origem, Destino, ListaVoos) :-
		voo(Origem, X, Cod1, _, _, _, _, _),
		roteiro(X, Destino, Lista),
		conc([Cod1|[]], Lista, ListaVoos).

% 3-	(1,5 pontos) Existe vôo direto entre duas cidades, num determinado dia da semana? A sua consulta deve retornar o dia da semana, o horário de saída, o horário de chegada e a companhia.
% ####### DONE ########

	filtra_voo_dia_semana(Origem,Destino, DiaSemana, HorarioSaida,HorarioChegada,Companhia):-
		voo(Origem, Destino, _, HorarioSaida, (_,HorarioChegada), 0, Companhia, Dias),
		pertence(DiaSemana, Dias).


% 4-	(3 pontos) Qual é o vôo ►direto◄ de menor duração entre duas cidades dadas, num determinado dia da semana? Sua consulta deve retornar dia da semana, horário de saída, horário de chegada e a companhia.
% ?-menorDuracao(Origem,Destino,dia,HorarioSaida,HorarioChegada,Companhia)

  listaVoosDiretos(X,X,[]).
  listaVoosDiretos(Origem, Destino, L) :-
    findall(Codigo, voo(Origem, Destino, Codigo, _, (_, _), 0, _, _), L).


	menorDuracao(Origem,Destino,Dia,HorarioSaida,HorarioChegada,Companhia) :-
		%voo_direto(Origem, Destino, Companhia, Dia, HorarioSaida).
		listaVoosDiretos(Origem, Destino, L),
    calculaMenorDuracao(L, Dia, HorarioSaida, HorarioChegada, Companhia, _).


%nao funciona se formato 8:00, mas sim com 800.
  calculaMenorDuracao([], _, _, _, _, 10000000).
  calculaMenorDuracao([H|T], Dia, Partida, Chegada, Companhia, Chegada - Partida) :-
    calculaMenorDuracao(T, _, _, _, _, DuraResto),
    voo(_, _, H, Partida, (_, Chegada),_ ,Companhia, Dia),
    Chegada - Partida =< DuraResto.

  calculaMenorDuracao([H|T], Dia, HorarioSaida, HorarioChegada, Companhia, Duracao) :-
    calculaMenorDuracao(T, Dia, HorarioSaida, HorarioChegada, Companhia, Duracao),
    voo(_, _, H, Partida, (_, Chegada),_, _, _),
    Chegada - Partida > Duracao.


% 5-	(3 pontos) Idem ao anterior, mostrando o dia e horário de partida e a duração total da viagem.
%  menor_roteiro(Origem, Destino, DiaSaída, HorSaida, Duração).

  menor_roteiro(Origem, Destino, DiaSaida, HorSaida, Duracao):-
    listaVoosDiretos(Origem, Destino, L),
    calculaMenorRoteiro(L, DiaSaida, HorSaida, Duracao).

  calculaMenorRoteiro([], _, _, 99999999999).
  calculaMenorRoteiro([H|T], DiaSaida, HorSaida, Duracao) :-
    calculaMenorRoteiro(T, _,_, DuraResto),
    voo(_,_,H, HorSaida, (_, HorChegada), _, _, DiaSaida),
    HorChegada - HorSaida =< DuraResto,
    Duracao is HorChegada - HorSaida.

  calculaMenorRoteiro([H|T], DiaSaida, HorSaida, Duracao) :-
    calculaMenorRoteiro(T, DiaSaida, HorSaida, Duracao),
    voo(_,_, H, Par, (_, Che), _, _,_),
    Duracao < Che - Par.
