cls :- write('\e[H\e[2J').%clear screen

%----------------- DEFINES ----------------
voo(sao-paulo, mexico, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(sao-paulo, nova-york, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(sao-paulo, lisboa, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(sao-paulo, madrid, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(sao-paulo, londres, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(sao-paulo, paris, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

voo(mexico, nova-york, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(mexico, madrid, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

voo(nova-york, londres, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

voo(londres, lisboa, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(londres, paris, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(londres, estocolmo, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

voo(madrid, paris, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(madrid, roma, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(madrid, frankfurt, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).

voo(frankfurt, estocolmo, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
voo(frankfurt, roma, código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).


%%----------------- FUNÇÕES ----------------
%voo(origem,destino,código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).
pertence(X,[X|_]).
pertence(X,[_|Calda]):-
  pertence(X,Calda).

conc([],L,L).
conc([X|L1],L2,[X|L]) :-
	conc(L1,L2,L).

% 1- (1 ponto) Verificar se eh possivel ir de uma cidade a outra sem escalas
voo_direto(Origem, Destino, _ ,_, _):-
  voo(Origem, Destino, _, _, 0, _, _, _).

% 2- 	(1,5 pontos) É possível viajar de uma cidade X a outra Y, ainda que seja necessário fazer conexões?
% Independente do tempo da conexão (poderia ser de até uma semana). A sua função deve retornar a lista códigos de vôos que serão realizados.


  



% 3-	(1,5 pontos) Existe vôo direto entre duas cidades, num determinado dia da semana?
% A sua consulta deve retornar o dia da semana, o horário de saída, o horário de chegada e a companhia.
filtra_voo_dia_semana(Origem,Destino, DiaSemana, HorarioSaida,HorarioChegada,Companhia):-
  voo(Origem, Destino, _, HorarioSaida, (_, HorarioChegada), 0, Companhia, Dias),
  pertence(Dias, DiaSemana).


%voo(origem,destino,código,partida,(dia_chegada,horario_chegada), número_de_escalas, companhia,[dias]).///////////////////////

% 4-	(3 pontos) Qual é o vôo direto de menor duração entre duas cidades dadas, num determinado dia da semana?
% Sua consulta deve retornar dia da semana, horário de saída, horário de chegada e a companhia.

 menorDuracao(Origem,Destino,Dia,HorarioSaida,HorarioChegada,Companhia):-
   filtra_voo_dia_semana(Origem, Destino, Dia, HorarioSaida, HorarioChegada, Companhia),
   menorDuracao(Origem, Destino, Dia, Hs, Hc, _),
   HorarioChegada - HorarioSaida =< Hc - Hs.
   


% 5-	(3 pontos) Idem ao anterior, mostrando o dia e horário de partida e a duração total da viagem.
menor_roteiro(Origem, Destino, DiaSaída, HorSaida, Duração).
