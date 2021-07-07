function prediction = isprime(N,ntests)
% vpi/isprime: use Fermat's little theorem to check if an odd number is prime
% usage: prediction = isprime(N,ntests)
%
% A single test will not always be a perfect predictor
% of primality, so multiple tests can be done. Two tests
% will be quite safe asa predictor.
% 
% 
% arguments: (input)
%  N - a scalar vpi integer, to be tested for primality
%
%  ntests - (OPTIONAL) scalar positive numeric integer.
%      ntests defines the number of successive tests
%      for various randomly chosen witnesses.
%
%      If ntests is actually a vector or array of numbers,
%      then the elements of ntests will be used for the
%      witnesses themselves.
%
%      DEFAULT: ntests = 2
%
% arguments: (output)
%  predictions - scalar, boolean
%
%      True if all of the witnesss predicted N to be
%      prime. If any of the predictions indicated N
%      to be composite, then N is definitely composite.
%
%
% Example:
%  isprime(vpi('10000000000037'))
% ans =
%      1
%
%  isprime(vpi(2:10))
% ans =
%      1     1     0     1     0     1     0     0     0
%
%  See also: isprime
% 
%  Author: John D'Errico
%  e-mail: woodchips@rochester.rr.com
%  Release: 3.0
%  Release date: 3/7/09

if (nargin<1) || (nargin>2)
  error('vpi/isprime allows only 1 or 2 arguments')
end

% Is this a scalar or an array?
if isempty(N)
  % empty propagates
  prediction = [];
  return
elseif numel(N) > 1
  % an array
  prediction = true(size(N));
  for i = 1:numel(N)
    if nargin == 1
      prediction(i) = isprime(N(i));
    else
      prediction(i) = isprime(N(i),ntests);
    end
  end
else
  % scalar N
  
  % error checks, defaults

  % make sure that N is a vpi, and positive
  N = abs(vpi(N));

  % simple cases. check to see if N is an even number, > 1
  if isunit(N)
    % 1 is not prime by definition.
    prediction = false;
    return
  elseif isequal(N,2)
    % 2 is prime
    prediction = true;
    return
  elseif comparemagnitudes(vpi(2^32),N)
    % small enough that isprime will suffice
    prediction = isprime(double(N));
    return
  elseif (mod(N.digits(1),2) == 0) || ...
      (mod(N.digits(1),5) == 0) || ...
      (mod(sum(N.digits),3) == 0)
    
    % multiple of 2 or 3 or 5
    prediction = false;
    return
  end

  % default for ntests is 2
  if (nargin<2) || isempty(ntests)
    ntests = 2;
  end
  if numel(ntests)>1
    % ntests was actually a vpi array of witnesses
    witnesses = ntests;
    ntests = numel(ntests);
    % make sure that witnesses was a vpi array
    witnesses = abs(vpi(witnesses));
  elseif (length(ntests)~=1) || ~isnumeric(ntests) || ...
      (ntests <= 0) || (ntests ~= round(ntests))
    error('ntests must be scalar, numeric, positive integer')
  else
    witnesses = [];
  end

  % pick candidate witnesses, if they were
  % not already supplied.
  if isempty(witnesses)
    % pick random integer(s) between 2 and N-1
    % randint generates random integers in [0,L]
    witnesses = randint(N-3,[ntests,1]) + 2;
  end
  
  % loop over the witnesses.
  Nm1 = N-1;
  predictions = true(1,ntests);
  notdone = true;
  i = 1;
  while notdone && (i <= ntests)
    w = witnesses(i);

    % use Fermat's little theorem
    % if N is truly prime, then mod(w^(N-1),N) == 1
    predictions(i) = (1 == powermod(w,Nm1,N));
    
    % if any of these tests predict composite,
    % then we are done.
    if ~predictions(i)
      notdone = false;
    else
      i = i + 1;
    end
  end

  % did any of the primaity tests predict composite?
  prediction = all(predictions);
end



