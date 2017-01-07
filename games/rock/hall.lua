-----------------------------------
-- Зал
-----------------------------------

hall = room {
  nam = 'Зал',
  enter = [[ Я вышел в зал через служебный проход. ]],
  --pic = 'img/hall.jpg',
  obj = {
    'security',
    vobj('crowd', [[ Зал уже забит битком, люди напирают на защитное ограждение, пытаясь занять лучшие места. ]]),
    'girls',
    'lesly',
    'rita',
    'nancy',
  },
  way = {
    vroom('За кулисы', 'passage'),
    'scene',
  },
  enter = function()
    set_music('mus/large-crowd-applause.ogg')
  end,
  act = code [[]],
}


girls = obj {
  nam = 'группа фанаток',
  dsc = [[ В первых рядах можно различить группу {девушек} из официального фанклуба
    в красных футболках «Bad Instead – The Best!» и с огромными плакатами в руках. ]],
  _seen = false,
  act = function(s)
    if not s._seen or steve._aim ~= 1 then
      p [[ Надеюсь, они выживут в этой давке – все как на подбор хрупкой модельной комплекции и едва одеты… ]]
      if steve._aim == 1 then
        s._seen = true
      end
    elseif not seen('lesly') then
      p [[ Я попытался разглядеть девушек сквозь клубы цветного дыма. ]]
      enable('lesly')
    elseif not seen('rita') then
      p [[ Я рассмотрел девушек внимательнее. ]]
      enable('rita')
    elseif not seen('nancy') then
      p [[ Я рассмотрел девушек внимательнее. ]]
      enable('nancy')
    else
      p [[ Надеюсь, они выживут в этой давке – все как на подбор хрупкой модельной комплекции и едва одеты… ]]
    end
  end,
}

lesly = obj {
  nam = 'Лесли',
  _is_girl = true,
  dsc = [[ Ближе всех ко мне находится сияющая белозубой улыбкой очаровательная {блондинка}. ]],
  _talk = 0,
  act = code [[ walk 'dlg_lesly' ]],
}:disable();

rita = obj {
  nam = 'Рита',
  _is_girl = true,
  dsc = [[ Сразу за ней пританцовывает {темноволосая девушка} в кожаной мини-юбке. ]],
  _talk = 0,
  act = code [[ walk 'dlg_rita' ]],
}:disable();

nancy = obj {
  nam = 'Нэнси',
  _is_girl = true,
  dsc = function()
    if here() == hall then
      p [[ Рядом с подругами стоит панковатого вида {девица} с коротким темным ежиком на голове. ]]
    elseif here() == room_steve then
      p [[ а на его коленях по-хозяйски устроилась о чём-то весело щебечущая {Нэнси}. ]]
    end
  end,
  _talk = 0,
  act = function()
    if here() == hall then
      walk 'dlg_nancy'
    elseif cup:need('aspirin') then
      walk 'dlg_nancy_aspirin'
    else
      p [[ Она улыбается мне, но не отводит глаз от Стива. ]]
    end
  end,
  inv = [[ Нэнси смотрит на меня с нетерпением, ожидая, когда же я представлю ее Стиву. ]],
}:disable();

security = obj {
  nam = 'охранник',
  _tips = false,
  _ok = false,
  dsc = function(s)
    if not s._tips then
      p [[ Проход охраняет двухметровый {амбал}, которого я, кажется, раньше здесь не видел.
        Он меланхолично жует жвачку, наблюдая за беснующейся толпой.^ ]]
    else
      p [[ Даже когда {охранник} мне заговорщицки подмигивает, с его физиономией это выглядит скорее угрожающе.^ ]]
    end
  end,
  act = function(s)
    if nancy._talk >= 3 and not have(nancy) then
      walk 'dlg_security'
    else
      p [[ Он так сурово выглядит… лучше без нужды его не тревожить. Я не трус, но я его боюсь! ]]
    end
  end,
  used = function(s, w)
    if w == money then
      p [[ Я украдкой протягиваю охраннику те деньги, что получил от босса.
        Он суёт купюры в карман униформы и зверски (по его мнению – обаятельно) улыбается мне.
        Надеюсь, это значит, что теперь с ним можно будет договориться. ]]
      inv():del(money)
      s._tips = true
    else
      p [[ Нет, я дорожу своим здоровьем. ]]
    end
  end,
}

dlg_security = dlg {
  nam = 'Охранник',
  --pic = 'img/hall.jpg',
  hideinv = true,
  entered = [[ Отчего-то немного робея, я подошел к охраннику. ]],
  talk = {
    {
      persist = true,
      cond = code [[ return not security._tips and (seen(nancy, hall) or have(nancy))]],
      [[ Вы не могли бы мне помочь? ]],
      act = [[ -- Чо надо? ]],
      {
        [[ Пропустите внутрь вон ту девушку, Нэнси. Пожалуйста. ]],
        act = [[ -- Неа. Мне велено никого не пускать. Катись-ка ты отсюда, манагер-шманагер. ]],
      },
    },
    {
      persist = true,
      cond = code [[ return security._tips and not security._ok ]],
      [[ Теперь я могу рассчитывать на вашу помощь? ]],
      act = [[ -- Ага, брат. Напомни, чо там надо? ]],
      {
        [[ Пропустите внутрь вон ту девушку, Нэнси. Пожалуйста. ]],
        act = function()
          p [[ -- Лады, пускай идет. Отсюда вижу, что оружие ей прятать некуда, хе-хе. ]]
          security._ok = true
        end,
      },
    },
    {
      persist = true,
      [[ Пожалуй, я лучше пойду. ]],
    },
  },
}

dlg_lesly = dlg {
  nam = 'Лесли',
  --pic = 'img/hall.jpg',
  hideinv = true,
  entered = [[ Я подошел к блондинке. ]],
  talk = {
    {
      [[ Привет. Как тебя зовут? ]],
      stage = 'top',
      act = function()
        p [[ -- Я -- Лесли. ]]
        lesly._talk = lesly._talk + 1;
      end,
    },
    {
      [[ Давно ждёшь тут? ]],
      stage = 'top',
      act = function()
        p [[ -- Да уж, полтора часа… но я сюда пришла ради своего любимого участника,
          и ничто не заставит меня сойти с этого места, пока я не разгляжу его вблизи! ]]
        lesly._talk = lesly._talk + 1;
      end
    },
    {
      cond = code [[ return lesly._talk >= 2 ]],
      persist = true,
      [[ Кто твой любимый участник? ]],
      act = [[ -- Джо… он такой милашка! ]],
    },
    {
      [[ У нас немного приболел ударник, плохо себя чувствует. У тебя не найдется для него таблетки аспирина? ]],
      cond = code [[ return cup:need('aspirin') ]],
      act = [[ К сожалению, нет. ]],
    },
    {
      [[ А ты симпатичная! ]],
      persist = true,
      act = [[ -- Спасибо! ]],
    },
  },
}

dlg_rita = dlg {
  nam = 'Рита',
  --pic = 'img/hall.jpg',
  hideinv = true,
  entered = [[ Я подошел к брюнетке. ]],
  talk = {
    {
      [[ Привет. Как тебя зовут? ]],
      stage = 'top',
      act = function()
        p [[ -- Я -- Рита. ]]
        rita._talk = rita._talk + 1
      end,
    },
    {
      [[ Давно ждёшь тут? ]],
      stage = 'top',
      act = function()
        p [[ -- Почти два часа! Но я уверена, шоу будет этого стоить!
          К тому же, моего любимого участника можно рассмотреть только из первых рядов… ]]
        rita._talk = rita._talk + 1
      end,
    },
    {
      [[ Кто твой любимый участник? ]],
      cond = code [[ return rita._talk >= 2 ]],
      persist = true,
      act = [[ -- Конечно же Чак!
      О, эти сильные руки, заставляющие барабаны и мое сердце биться в сумасшедшем ритме… ]],
    },
    {
      [[ Чак немного приболел и не может выступать. У тебя не найдется для него таблетки аспирина? ]],
      cond = code [[ return cup:need('aspirin') ]],
      persist = true,
      act = function()
        p [[ -- Конечно! У меня вроде бы оставалось немного в сумочке, а для Чака мне ничего не жалко! --
        Рита так долго копалась в свом крохотном клатче, что я почти потерял надежду. Наконец она выудила таблетку аспирина -- Вот, пожалуйста! ]]
        take('aspirin')
      end,
    },
    {
      [[ А ты симпатичная! ]],
      persist = true,
      act = [[ -- Спасибо! ]],
    },
  },
}

dlg_nancy = dlg {
  nam = 'Нэнси',
  --pic = 'img/hall.jpg',
  hideinv = true,
  entered = [[ Я подошел к панковатой девице. ]],
  talk = {
    {
      [[ Привет. Как тебя зовут? ]],
      stage = 'top',
      act = function()
        p [[ -- Я -- Нэнси. ]]
        nancy._talk = nancy._talk + 1
      end,
    },
    {
      [[ Давно ждёшь тут? ]],
      stage = 'top',
      act = function()
        p [[ -- Ну так, не то чтобы очень давно… На концертах всегда ждёшь.
          Чего не сделаешь ради возможности увидеть своего любимого участника вживую и так близко! ]]
        nancy._talk = nancy._talk + 1
      end,
    },
    {
      [[ Кто твой любимый участник? ]],
      cond = code [[ return nancy._talk >= 2 ]],
      persist = true,
      act = function()
        p [[ -- Стив! От его голоса я просто таю… ^^ Так, кажется, я теперь знаю, как уговорить Стива выступать... ]]
        nancy._talk = nancy._talk + 1
      end,
    },
    {
      [[ Хочешь, устрою тебе свидание со Стивом? ]],
      cond = code [[ return security._ok ]],
      persist = true,
      act = function()
        p [[ -- Ещё-бы! Конечно, я готова! ]]
        takef(nancy, hall) -- По идее она должна быть в зале
      end,
    },
    {
      [[ А ты симпатичная! ]],
      persist = true,
      act = [[ -- Спасибо! ]],
    },
  },
}

dlg_nancy_aspirin = dlg {
  nam = 'Нэнси',
  --pic = 'img/hall.jpg',
  hideinv = true,
  entered = [[ Интересно, а вдруг она носит с собой какие-нибудь таблетки? ]],
  talk = {
    {
      [[ Нэнси, может у тебя есть аспирин? ]],
      persist = true,
      act = [[ -- У меня нет, но, вполне может быть у моей подруги. ]],
    },
  },
}

-----------------------------------
-- Сцена (фиктивная комната)
-----------------------------------

scene = room {
  nam = 'На сцену',
  enter = function()
    p [[ Нет уж, пусть на сцену выходят "Bad Instead" ]]
    return false
  end,
}
