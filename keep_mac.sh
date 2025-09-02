#!/bin/zsh

# 配置
DAILY_START_TIME="0600"   # 24小时格式，如 "0700"
INTERVAL_HOURS=5          # 间隔小时数
WINDOW_MIN=10             # 触发窗口（分钟）

# 计算四个执行时间（基于分钟，自然跨天）
INTERVAL_MIN=$((INTERVAL_HOURS * 60))
START_HOUR=${DAILY_START_TIME:0:2}
START_MIN=${DAILY_START_TIME:2:2}
START_MINUTES=$((10#$START_HOUR * 60 + 10#$START_MIN))

typeset -a TIMES_MINUTES PROMPTS LAST_RUN_DAY
TIMES_MINUTES=()
for i in {0..3}; do
  TIMES_MINUTES+=$(( (START_MINUTES + i * INTERVAL_MIN) % 1440 ))
done

PROMPTS=(
  "What day is it today?"
  "What time is it now?"
  "What's the weather like outside now?"
  "What's your name?"
)

# 最近一次运行对应的“天索引”（自 epoch 起的天数），初始为 -1
LAST_RUN_DAY=(-1 -1 -1 -1)

# 打印计划时间
print -n "执行时间设置: "
for i in {1..4}; do
  t=${TIMES_MINUTES[$i]}
  hh=$(printf "%02d" $(( t / 60 )))
  mm=$(printf "%02d" $(( t % 60 )))
  if [[ $i -gt 1 ]]; then print -n ", "; fi
  print -n "${hh}${mm}"
done
print ""

while true; do
  NOW_H=$(date +%H)
  NOW_M=$(date +%M)
  NOW_MIN=$((10#$NOW_H * 60 + 10#$NOW_M))
  DAY_IDX=$(( $(date +%s) / 86400 ))  # 天索引

  for i in {1..4}; do
    slot=${TIMES_MINUTES[$i]}
    # 距槽位的分钟差（取模 1440），0..WINDOW_MIN 内触发
    diff=$(( (NOW_MIN - slot + 1440) % 1440 ))
    if [[ $diff -le $WINDOW_MIN && ${LAST_RUN_DAY[$i]} -ne $DAY_IDX ]]; then
      claude -p "${PROMPTS[$i]}"
      echo "执行时间: $(date +'%Y-%m-%d %H:%M:%S') - 槽位$((i)) 执行"
      LAST_RUN_DAY[$i]=$DAY_IDX
    fi
  done

  sleep 30
done
